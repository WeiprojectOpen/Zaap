//
//  YPUIMessage.h
//  YMG
//
//  Created by flannian on 9/28/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YPMAXAPNLENGTH 100

@class  MBProgressHUD;

@interface YPUIMessage : NSObject <UIAlertViewDelegate>

@property (nonatomic,readonly,strong) MBProgressHUD *progressHUD;

//Normal alert view
- (void) showOkMsg: (NSString *) title andMessage: (NSString *) message;
- (void) showErrorMsg: (NSString *) title andMessage: (NSString *) message;
- (void) showMsg: (NSString *) title andMessage: (NSString *) message forStatus: (BOOL) status withCaption: (NSString *) caption;
- (void) showError: (NSError *) error message: (NSString *) message;

//Progress HUD
- (void)showProgressHUDWithMessage:(NSString *)message afterDelay: (NSTimeInterval)delay key: (NSString *)key;
- (void)showProgressHUDWithMessage:(NSString *)message;
- (void)showProgressHUDWithMessage:(NSString *)message inView: (UIView *) view;
- (void)hideProgressHUD:(BOOL)animated;
- (void)showProgressHUDCompleteMessage:(NSString *)message;
- (void)hideProgressHUD:(BOOL)animated withKey: (NSString *) key;

//Confirm alert view
- (void) showConfirmDlgWithTitle: (NSString *) title
                             Msg:(NSString *)message
                              ok:(void (^)())ok
                          cancel:(void (^)())cancel;

- (void) closeConfirmDlg;
- (void) showLocalNotification: (NSString *) alertAction alertBody: (NSString *) alertBody showAlert: (BOOL) showAlert playSound: (BOOL) playSound;
- (void) resetRemoteNotificationsWithEnabled:(BOOL) enabled showAlert: (BOOL) showAlert playSound: (BOOL) playSound;

- (void) showNeedNetworkConnectionMessage;

@end
