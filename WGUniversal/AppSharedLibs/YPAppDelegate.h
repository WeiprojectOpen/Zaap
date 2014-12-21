//
//  YPAppDelegate.h
//  YMG
//
//  Created by flannian on 9/29/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPSysInfo.h"
#import "YPUIMessage.h"
#import "YPNetwork.h"
//#import "XMPPLogging.h"
//#import "UIView+position.h"

#define kDefaultUISearchBarHeight 44.f
#define kDefaultUIToolBarHeight 44.f

@protocol YPModalActionDelegate <NSObject>
- (void) closeModal;
- (void) closeModalAndPerformSelector:(SEL) aSelector withObject: (id)object;
@end

@interface YPAppDelegate : UIResponder <UIApplicationDelegate, YPModalActionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) YPSysInfo *sys;
@property (strong, nonatomic) YPUIMessage *msg;
@property (strong, nonatomic) YPNetwork *net;
@property (strong, nonatomic) UIViewController *hiddenModalViewController;

@property (strong, nonatomic) NSSet *inAppProductIdentifiers;

- (void)safeUpdateUI: (void (^)()) method;
+ (YPAppDelegate*) me;
- (void)saveOption: (NSString *) key value : (id) value;
- (id)settingsForKey : (NSString *) key;
- (void) addTopMostView: (UIView *) view;

- (void) initKeyboarHook: (UIView *) viewToHook viewToResize: (UIView *) viewToResize onlyChangeHeight: (BOOL) onlyChangeHeight;

- (void) recheckInternetReachable;

- (void) handleURL: (NSURL *) url;

- (void) presentModalViewControllerTwo: (UIViewController *)viewController;

- (void) dismissModalViewControllerTwo;

- (void) logViewAndParentsFrame: (UIView *) view withKey: (NSString *) key;

@end
