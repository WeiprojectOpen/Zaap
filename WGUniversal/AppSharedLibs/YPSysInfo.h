//
//  YPSysInfo.h
//  YMG
//
//  Created by flannian on 9/28/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface YPSysInfo : NSObject <MFMailComposeViewControllerDelegate>

@property (nonatomic,assign) BOOL isIphone5;
@property (nonatomic,assign) BOOL isIpad;
@property (nonatomic,assign) CGFloat deviceScale;
@property (nonatomic,assign) CGFloat iphoneToPadScale;
@property (nonatomic,assign) CGFloat iphoneToPadScale15;

@property (nonatomic,readonly) NSString *appDisplayName;
@property (nonatomic,readonly) NSString *appName;
@property (nonatomic,readonly) NSString *appDomain;
@property (nonatomic,readonly) NSString *deviceId;
@property (nonatomic,readonly) NSString *countryCode;

@property (nonatomic,strong) NSString *appSecureKey;

- (BOOL) mailDeviceInfoAndLogsTo: (NSString *) email title: (NSString *) title body: (NSString *) body;

@end
