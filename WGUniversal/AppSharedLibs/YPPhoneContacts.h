//
//  YPPhoneContacts.h
//  SharedLibs
//
//  Created by flannian on 11/19/13.
//  Copyright (c) 2013 pc2pp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol YPPhoneContactsSyncDelegate
- (void) phoneContactsSyncStarted;
- (void) phoneContactsSyncFinished;
@end;

@protocol YPPhoneContactsUserDelegate
- (NSDictionary *) getUserInfoPhoneNumbers:(NSArray *)phoneNumbers;
@end;

@interface YPPhoneContacts : NSObject

@property (nonatomic, readonly) NSArray * contacts;
@property (nonatomic, strong) NSObject <YPPhoneContactsSyncDelegate> *syncDelegate;
@property (nonatomic, strong) NSObject <YPPhoneContactsUserDelegate> *userInfoDelegate;

- (void) initContactList;
- (void) phoneAddressBookExternalChangeCallback: (ABAddressBookRef) addressBook;
- (UIImage*) imageForContactId: (int) contactId;
@end
