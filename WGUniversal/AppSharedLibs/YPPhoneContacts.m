//
//  YPPhoneContacts.m
//  SharedLibs
//
//  Created by flannian on 11/19/13.
//  Copyright (c) 2013 pc2pp.com. All rights reserved.
//

#import "YPPhoneContacts.h"
#import "YPAppDelegate.h"
#import "NBPhoneNumberUtil.h"
#import "YPUserItem.h"

// Log levels: off, error, warn, info, verbose
//#if DEBUG
//static const int xmppLogLevel = XMPP_LOG_LEVEL_VERBOSE | XMPP_LOG_FLAG_TRACE; // | XMPP_LOG_FLAG_TRACE;
//#else
//static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
//#endif

void phoneAddressBookExternalChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    [((__bridge YPPhoneContacts *)context) phoneAddressBookExternalChangeCallback: addressBook];
}

@interface YPPhoneContacts() {
    NSArray *_contacts;
    NSArray *_arrayOfPeople;
    NSArray *_arrayOfPhoneNumbers;
}
@end

@implementation YPPhoneContacts

/*- (id) init {
    if(self = [super init]) {
        [self initContactList];
    }
    return self;
}*/

- (NSArray *) contacts {
    if(_contacts == nil) {
        [self initContactList];
    }
    return _contacts;
}

-(void) phoneAddressBookExternalChangeCallback: (ABAddressBookRef) addressBook{
    [self generateContacts:addressBook];
}

- (void) initContactList {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        [self generateContacts:addressBook];
    }
}

- (void) generateContacts: (ABAddressBookRef) addressBook {
    if(_syncDelegate!=nil && [_syncDelegate respondsToSelector:@selector(phoneContactsSyncStarted)]) {
        [_syncDelegate phoneContactsSyncStarted];
    }
    [NSThread detachNewThreadSelector:@selector(generateContactsInAnotherThread:) toTarget:self withObject:(__bridge id)(addressBook)];
    //[self generateContacts:addressBook];
}


- (void) generateContactsInAnotherThread: (ABAddressBookRef) addressBook{
    _arrayOfPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    XMPPLogVerbose(@"arrayOfPeople = %@", _arrayOfPeople);
    if([_arrayOfPeople count]==0) return;
    
    ABAddressBookRegisterExternalChangeCallback(addressBook, phoneAddressBookExternalChangeCallback, (__bridge void *)(self));
    
    //The array in which the first names will be stored as NSStrings
    NSMutableArray *firstNames = [[NSMutableArray alloc] init];
    
//    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    
    
    for(NSUInteger index = 0; index <= ([_arrayOfPeople count]-1); index++){
        
        ABRecordRef currentPerson = (__bridge ABRecordRef)[_arrayOfPeople objectAtIndex:index];
        YPUserItem* userItem = [YPUserItem new];
        
        
        
        userItem.contactId = index;
        userItem.displayValue = (__bridge_transfer NSString *)(ABRecordCopyCompositeName(currentPerson));
        ABMultiValueRef numbers = ABRecordCopyValue(currentPerson, kABPersonPhoneProperty);
        NSString* targetNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(numbers, 0);
        
        NSArray* targetNumbers = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(numbers);
        CFRelease(numbers);
        
        NSDictionary *userInfo = nil;
        if(_userInfoDelegate!=nil && [_userInfoDelegate respondsToSelector:@selector(getUserInfoPhoneNumbers:)]) {
            userInfo = [_userInfoDelegate getUserInfoPhoneNumbers:targetNumbers];
        }
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(currentPerson,  kABPersonFirstNameProperty);
        if(firstName == nil)  firstName = @"";
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(currentPerson,  kABPersonLastNameProperty);
        if(lastName == nil)  lastName = @"";
        
        userItem.sortValue = ABPersonGetSortOrdering() == kABPersonSortByFirstName ?
        [NSString stringWithFormat:@"%@%@",  firstName, lastName]
        :[NSString stringWithFormat:@"%@%@", lastName,  firstName];
        XMPPLogVerbose(@"userItem.sortValue = %@", userItem.sortValue);
        
//        NSError *aError = nil;
//        NBPhoneNumber *phoneNumber = [phoneUtil parse:targetNumber defaultRegion:[YPAppDelegate me].sys.countryCode error:&aError];
        
        /*ABMultiValueRef addressProperty = ABRecordCopyValue(currentPerson, kABPersonAddressProperty);
         NSArray *address = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(addressProperty);
         NSString *country = nil;
         for (NSDictionary *addressDict in address)
         {
         country = [addressDict objectForKey:@"Country"];
         if(country!=nil) break;
         }
         CFRelease(addressProperty);*/
        
        userItem.selectValue =  targetNumber;
        //userItem.detailValue = aError == nil ? [phoneUtil format:phoneNumber numberFormat:NBEPhoneNumberFormatE164
                                                           //error:&aError] : targetNumber;
        userItem.detailValue = userInfo==nil ? nil : [userInfo objectForKey:@"detailValue"];
        userItem.userId = userInfo==nil ? 0 : [[userInfo objectForKey:@"userId"] intValue];
        
        
        userItem.facebookId = nil;
        userItem.selected = NO;
        //NSString *currentFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(currentPerson, kABPersonFirstNameProperty);
        //NSString *currentLastName = (__bridge_transfer NSString *)ABRecordCopyValue(currentPerson, kABPersonLastNameProperty);
        [firstNames addObject: userItem];
    }
    
    _contacts = firstNames;
    if(_syncDelegate!=nil && [_syncDelegate respondsToSelector:@selector(phoneContactsSyncFinished)]) {
        [_syncDelegate performSelectorOnMainThread:@selector(phoneContactsSyncFinished) withObject:nil waitUntilDone:NO];
    }
    
    //OPTIONAL: The following line sorts the first names alphabetically
    //_sortedContactList = [firstNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UIImage*)imageForContactId: (int) contactId {
    ABRecordRef contactRef = (__bridge ABRecordRef)[_arrayOfPeople objectAtIndex:contactId];
    UIImage *img = nil;
    
    // can't get image from a ABRecordRef copy
    ABRecordID contactID = ABRecordGetRecordID(contactRef);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABRecordRef origContactRef = ABAddressBookGetPersonWithRecordID(addressBook, contactID);
    
    if (ABPersonHasImageData(origContactRef)) {
        NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(origContactRef, kABPersonImageFormatOriginalSize);
        img = [UIImage imageWithData: imgData];
    }
    
    CFRelease(addressBook);
    
    return img;
}
@end
