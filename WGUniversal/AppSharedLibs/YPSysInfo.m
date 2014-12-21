//
//  YPSysInfo.m
//  YMG
//
//  Created by flannian on 9/28/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "YPSysInfo.h"
//#import "ZipArchive.h"
#import "YPAppDelegate.h"
//#import "SecureUDID.h"

// Log levels: off, error, warn, info, verbose
//#if DEBUG
//static const int xmppLogLevel = XMPP_LOG_LEVEL_VERBOSE | XMPP_LOG_FLAG_TRACE; // | XMPP_LOG_FLAG_TRACE;
//#else
//static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
//#endif

@implementation YPSysInfo {
    NSString *_appName;
    NSString *_appDisplayName;
    NSString *_appDomain;
    NSString *_deviceId;
    NSString *_countryCode;
}

+ (BOOL) isIpad {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
	{
        return([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
	}
    return(NO);
}

+ (BOOL) isRetinaDisplay{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? YES : NO;
}

- (NSString *) appDisplayName {
    if(_appDisplayName == nil) {
        _appDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    }
    return _appDisplayName;
}

- (NSString *) countryCode {
    if(_countryCode == nil) {
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netinfo subscriberCellularProvider];
        
        if(carrier) {
            _countryCode = [[carrier isoCountryCode] uppercaseString];
        }
        else {
            _countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        }
    }
    return _countryCode;
}


- (NSString *) appName {
    if(_appName == nil) {
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
    return _appName;
}

- (NSString *) appDomain {
    if(_appDomain == nil) {
        _appDomain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    }
    return _appDomain;
}

//- (NSString *) deviceId {
//    if(_deviceId == nil) {
//        _deviceId = [SecureUDID UDIDForDomain:self.appDomain usingKey:self.appSecureKey];
//    }
//    return _deviceId;
//    //return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//}

- (id) init {
    if(self = [super init]) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _isIpad = [[self class] isIpad];
        _isIphone5 = (!_isIpad) && screenSize.height> 480.f;
        _deviceScale = [[self class] isRetinaDisplay] ? 2.0 : 1.0;
        _iphoneToPadScale = _isIpad ? 1024.f/480.f : 1.0f;
        _iphoneToPadScale15 = _isIpad ? 1.5f : 1.0f;
    }
    return self;
}

//- (NSString *) zipLogsFolder {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cacheDirectory = [paths objectAtIndex:0];
//    BOOL isDir=NO;
//    NSArray *subpaths;
//    NSString *exportPath = [cacheDirectory stringByAppendingString:@"/logs"];;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
//        subpaths = [fileManager subpathsAtPath:exportPath];
//    }
//    
//    NSString *archivePath = [cacheDirectory stringByAppendingString:@"/logs.zip"];
//    
//    ZipArchive *archiver = [[ZipArchive alloc] init];
//    [archiver CreateZipFile2:archivePath];
//    for(NSString *path in subpaths)
//    {
//        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
//        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
//        {
//            [archiver addFileToZip:longPath newname:path];
//        }
//    }
//    
//    BOOL successCompressing = [archiver CloseZipFile2];
//    if(successCompressing) {
//        XMPPLogVerbose(@"Zip logs success");
//        return archivePath;
//    }
//    else {
//        XMPPLogVerbose(@"Zip logs fail");
//        return nil;
//    }
//}
//
//- (BOOL) mailDeviceInfoAndLogsTo: (NSString *) email title: (NSString *) title body: (NSString *) body {
//    if ([MFMailComposeViewController canSendMail]) {
//        NSString *logFile = [self zipLogsFolder];
//        if(logFile!=nil) {
//            
//            MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
//            emailer.mailComposeDelegate = self;
//            
//            [emailer setSubject:title];
//            
//            [emailer setMessageBody:body isHTML:NO];
//            
//            [emailer setToRecipients: [NSArray arrayWithObject:email]];
//            
//            [emailer addAttachmentData:[NSData dataWithContentsOfFile:logFile] mimeType:@"application/zip" fileName:@"logs.zip"];
//            
//            [[YPAppDelegate me].window.rootViewController presentModalViewController:emailer animated:YES];
//        }
//    }
//    return false;
//}
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
//    if (result == MFMailComposeResultFailed) {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EMAIL", @"Email")
//            message:NSLocalizedString(@"EMAIL_SEND_FAIL", @"Email failed to send. Please try again.")
//            delegate:nil cancelButtonTitle:NSLocalizedString(@"DISMISS", @"Dismiss") otherButtonTitles:nil] ;
//		[alert show];
//    }
//	[[YPAppDelegate me].window.rootViewController dismissModalViewControllerAnimated:YES];
//}


@end
