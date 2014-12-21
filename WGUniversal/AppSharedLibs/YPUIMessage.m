//
//  YPUIMessage.m
//  YMG
//
//  Created by flannian on 9/28/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import "YPUIMessage.h"
#import "MBProgressHUD.h"
#import "YPAppDelegate.h"
#import "NSString+Truncation.h"

@interface YPUIMessage() {
    MBProgressHUD *_progressHUD;
    id okCallback;
    id cancelCallback;
    UIAlertView *_alert;
    NSMutableDictionary *_dict;
}
@end

@implementation YPUIMessage

- (void) showNeedNetworkConnectionMessage {
    //[self showOkMsg: nil andMessage: NSLocalizedString(@"NeedNetworkConnectionMessage", @"This operation failed. You are currently not connected.")];
    [self showOkMsg: nil andMessage: @"网络不通，请检查网络设置。"];
}

- (void) showError: (NSError *) error message: (NSString *) message {
    [self showErrorMsg:nil andMessage:[error localizedDescription]];
}

- (void) showOkMsg: (NSString *) title andMessage: (NSString *) message {
    [self showMsg: title andMessage: message forStatus: FALSE withCaption: NSLocalizedString(@"OK", @"Ok")];
}

- (void) showErrorMsg: (NSString *) title andMessage: (NSString *) message {
    [self showMsg: title andMessage: message forStatus: TRUE withCaption: NSLocalizedString(@"CLOSE", @"Close")];
}

- (void) showMsg: (NSString *) title andMessage: (NSString *) message forStatus: (BOOL) status withCaption: (NSString *) caption {
    [[YPAppDelegate me] safeUpdateUI:^(void){
        // open a alert with an OK
        UIAlertView *dialog = [[UIAlertView alloc] init];
        [dialog setDelegate: self];
        [dialog setTitle: title ? title : [YPAppDelegate me].sys.appDisplayName];
        [dialog setMessage: message];
        [dialog addButtonWithTitle: caption];
        
        //UILabel *theBody = [dialog valueForKey: @"_bodyTextLabel"];
        //if (status) {
        //[theBody setTextColor:[UIColor redColor]];
        // }
        
        [dialog show];
    }];
}

#pragma mark - MBProgressHUD

- (MBProgressHUD *)progressHUD {
    if (_progressHUD==nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:[YPAppDelegate me].window];
        
        _progressHUD.minSize = CGSizeMake(120, 120);
        _progressHUD.minShowTime = 0.3;
        _progressHUD.opacity = 0.75;
        // The sample image is based on the
        // work by: http://www.pixelpressicons.com
        // licence: http://creativecommons.org/licenses/by/2.5/ca/
        _progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/Checkmark.png"]];
        
        //[self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message inView: (UIView *) view {
    [self showProgressHUDWithMessage:message inView:view withMode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUDWithMessage:(NSString *)message inView: (UIView *) view withMode: (MBProgressHUDMode) mode{
    
    if(view==nil) {
        //[root addTopMostView: _progressHUD];
        
        if([YPAppDelegate me].window.rootViewController.modalViewController != nil) {
            
        }
        
        view = [YPAppDelegate me].window.rootViewController.modalViewController != nil ? [YPAppDelegate me].window.rootViewController.modalViewController.view : [YPAppDelegate me].window.rootViewController.view;
    }
    
    //dismiss keyboard
    [view endEditing:YES];
    
    //if(_progressHUD!=nil) [_progressHUD removeFromSuperview];
    self.progressHUD.labelText = message;
    self.progressHUD.mode = mode;
    
    
    
    if(_progressHUD.superview!=nil && _progressHUD.superview!=view) {
        [_progressHUD removeFromSuperview];
        [view addSubview:_progressHUD];
    }
    else if(_progressHUD.superview==nil) {
        [view addSubview:_progressHUD];
        //[view sendSubviewToBack:_progressHUD];
    }
    
    [self.progressHUD show:NO];
}

- (void)showProgressHUDWithMessage:(NSString *)message {
    [self showProgressHUDWithMessage:message inView:nil];
}

- (void) delayDetectShowProgressHUDWithKey:(NSArray *)key {
    NSString *message = [_dict objectForKey:key];
    if(message !=nil) {
        [self showProgressHUDWithMessage:message];
    }
}

- (void)showProgressHUDWithMessage:(NSString *)message afterDelay: (NSTimeInterval)delay key: (NSString *)key {
    if(_dict ==nil) {_dict = [NSMutableDictionary dictionary];}
    [_dict setObject:message forKey:key];
    [self performSelector:@selector(delayDetectShowProgressHUDWithKey:) withObject:key afterDelay:delay];
}

- (void)hideProgressHUD:(BOOL)animated withKey: (NSString *) key {
    if(_dict!=nil && [_dict objectForKey:key]!=nil) {
        [_dict removeObjectForKey:key];
    }
    [self hideProgressHUD:animated];
}

- (void)hideProgressHUD:(BOOL)animated {
    [self.progressHUD hide:animated];
    if(_progressHUD.superview!=nil) {
        [_progressHUD removeFromSuperview];
    }
    //self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    if (message) {
        [self showProgressHUDWithMessage:message inView:nil withMode:MBProgressHUDModeCustomView];
        [self.progressHUD hide:YES afterDelay:1.5];
    } else {
        [self.progressHUD hide:YES];
    }
    //self.navigationController.navigationBar.userInteractionEnabled = YES;
}

#pragma mark - Confirm alert view
- (void) showConfirmDlgWithTitle: (NSString *) title
                             Msg:(NSString *)message
                              ok:(void (^)())ok
                          cancel:(void (^)())cancel {
    if(ok) {
        okCallback = ok;
    }
    
    if(cancel) {
        cancelCallback = cancel;
    }
    
    _alert = [[UIAlertView alloc] init];
	[_alert setTitle:title==nil ? [YPAppDelegate me].sys.appDisplayName : title];
	[_alert setMessage:message];
	[_alert setDelegate:self];
	[_alert addButtonWithTitle:NSLocalizedString(@"YES", @"Yes")];
	[_alert addButtonWithTitle:NSLocalizedString(@"NO", @"No")];
	[_alert show];
}

/*NSLocalizedStringWithDefaultValue(@"GCDAsyncSocketReadTimeoutError",
                                  @"GCDAsyncSocket", [NSBundle mainBundle],
                                  @"Read operation timed out", nil);*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		// Yes, do something
        if(okCallback) {
            ((void (^)())okCallback)();
        }
	}
	else if (buttonIndex == 1)
	{
		// No
        if(cancelCallback) {
            ((void (^)())cancelCallback)();
        }
	}
    okCallback = nil;
    cancelCallback = nil;
}

- (void) closeConfirmDlg {
    if(_alert!=nil) {
        okCallback = nil;
        cancelCallback = nil;
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
        _alert = nil;
    }
}

#pragma mark - Local Notification
- (void) showLocalNotification: (NSString *) alertAction alertBody: (NSString *) alertBody showAlert: (BOOL) showAlert playSound: (BOOL) playSound {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(showAlert) {
        localNotification.alertAction = alertAction==nil ? @"Ok" : alertAction;
        NSString *apnText = [alertBody truncateWithEllipsisToUTF8Length:YPMAXAPNLENGTH];
        localNotification.alertBody = apnText;
        
    }
    if(!playSound) {
        localNotification.soundName = nil;
    }
    else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

#pragma mark - Remote Notification
- (void) resetRemoteNotificationsWithEnabled:(BOOL) enabled showAlert: (BOOL) showAlert playSound: (BOOL) playSound{
    #if !TARGET_IPHONE_SIMULATOR
    
    //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    if(enabled && (showAlert||playSound)) {
        UIRemoteNotificationType newTypes = UIRemoteNotificationTypeNone;
        if(showAlert&&playSound) {
            newTypes=
            UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        }
        else if(showAlert) {
            newTypes=
            UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge;
        }
        else if(playSound) {
            newTypes =  UIRemoteNotificationTypeSound;
        }
        
        //if (types != newTypes) {
        //  [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: newTypes];
        //}
    }
    else {
        if (types != UIRemoteNotificationTypeNone) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
    
    #endif
}

@end
