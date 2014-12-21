//
//  YPAppDelegate.m
//  YMG
//
//  Created by flannian on 9/29/13.
//  Copyright (c) 2013 MateMedia. All rights reserved.
//

#import "YPAppDelegate.h"
//#import "DDLog.h"
//#import "DDTTYLogger.h"
//#import "DDFileLogger.h"

//#import "UIApplication+TopMostView.h"
//#import "DAKeyboardControl.h"
//#import "UIView+position.h"

//#import "iRate.h"

// Log levels: off, error, warn, info, verbose
//#if DEBUG
//static const int xmppLogLevel = XMPP_LOG_LEVEL_VERBOSE | XMPP_LOG_FLAG_TRACE; // | XMPP_LOG_FLAG_TRACE;
//#else
//static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
//#endif

@interface YPAppDelegate() {
    dispatch_source_t _mainTimer;
}

@end

@implementation YPAppDelegate


- (id) init {
    if(self = [super init]) {
        _sys = [YPSysInfo new];
        _msg = [YPUIMessage new];
        _net = [YPNetwork new];
        
        // Configure logging framework
//        [DDLog addLogger:[DDTTYLogger sharedInstance]];
//        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
//        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//        
//        [DDLog addLogger:fileLogger];
//        
//        XMPPLogInfo(@"DDLog initialized with file logger");
    }
    return self;
}


+ (void)initialize
{
    //configure iRate
    //[iRate sharedInstance].daysUntilPrompt = 5;
    //[iRate sharedInstance].usesUntilPrompt = 15;
    
    //enable preview mode
    //[iRate sharedInstance].previewMode = YES;
    //[iRate sharedInstance].promptAtLaunch = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //XMPPLogTrace();
//    if([[iRate sharedInstance] shouldPromptForRating]) {
//        [[iRate sharedInstance] promptIfNetworkAvailable];
//    }
    
    return YES;
}

+ (YPAppDelegate*) me {
    return (YPAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)safeUpdateUI: (void (^)()) method {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), method);
}

- (void) recheckInternetReachable {
    
}

- (void) handleURL: (NSURL *) url {
    
}

- (void) logViewFrame: (UIView *) view withKey: (NSString *) key{
    //XMPPLogVerbose(@"%@ view %@ frame: %@,  bounds: %@", key, [view class], NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));
}

- (void) logViewAndParentsFrame: (UIView *) view withKey: (NSString *) key{
    [self logViewFrame:view withKey:key];
    UIView *superView = view.superview;
    while (superView != nil) {
        [self logViewFrame:superView withKey:key];
        superView = superView.superview;
    }
}

- (NSSet *)inAppProductIdentifiers {
    return [NSSet setWithObjects:[self removeAdsProductIdentifier], nil];
}

- (NSString *)removeAdsProductIdentifier {
    return @"com.unknown.remove_ads";
}

- (void) presentModalViewControllerTwo: (UIViewController *)viewController {
    
    _hiddenModalViewController = [[self class] me].window.rootViewController.modalViewController;
    if(_hiddenModalViewController != nil) {
        [[[self class] me].window.rootViewController dismissViewControllerAnimated:YES completion:^{
            [[[self class] me].window.rootViewController presentModalViewController:viewController animated:YES];
        }];
    }
    else {
        [[[self class] me].window.rootViewController presentModalViewController:viewController animated:YES];
    }
}

- (void) dismissModalViewControllerTwo {
    if(_hiddenModalViewController != nil) {
        [[[self class] me].window.rootViewController dismissViewControllerAnimated:YES completion:^{
            [[[self class] me].window.rootViewController presentModalViewController:_hiddenModalViewController animated:YES];
            _hiddenModalViewController = nil;
        }];
    }
    else {
        [[[self class] me].window.rootViewController dismissModalViewControllerAnimated: YES];
    }
}


//- (void) addTopMostView: (UIView *) view {
//    if(view.superview!=nil) {[view removeFromSuperview];}
//    UIApplication *app = [UIApplication sharedApplication];
//    [app addSubViewOnFrontWindow:view];
//}

- (void)saveOption : (NSString *) key value : (id) value
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	} else {
		//XMPPLogError(@"Unable to save %@ = %@ to user defaults", key, value);
	}
}

- (id)settingsForKey : (NSString *) key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	id val = nil;
    
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
    
	// TODO: / apparent Apple bug: if user hasn't opened Settings for this app yet (as if?!), then
	// the defaults haven't been copied in yet.  So do so here.  Adds another null check
	// for every retrieve, but should only trip the first time
	if (val == nil) {
		//XMPPLogWarn(@"user defaults may not have been loaded from Settings.bundle ... doing that now ...");
		//Get the bundle path
		NSString *bPath = [[NSBundle mainBundle] bundlePath];
		NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.inApp.plist"];
        
		//Get the Preferences Array from the dictionary
		NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
		NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
		//Loop through the array
		NSDictionary *item;
		for(item in preferencesArray)
		{
			//Get the key of the item.
			NSString *keyValue = [item objectForKey:@"Key"];
            
			//Get the default value specified in the plist file.
			id defaultValue = [item objectForKey:@"DefaultValue"];
            
			if (keyValue && defaultValue) {
				[standardUserDefaults setObject:defaultValue forKey:keyValue];
				if ([keyValue compare:key] == NSOrderedSame)
					val = defaultValue;
			}
		}
		[standardUserDefaults synchronize];
	}
	return val;
}

//- (void) initKeyboarHook: (UIView *) viewToHook viewToResize: (UIView *) viewToResize onlyChangeHeight: (BOOL) onlyChangeHeight{
//    __unsafe_unretained __block UIView *keyboardHookView = viewToHook;
//    
//    __block CGRect originFrame = viewToResize.frame;
//    
//    __block CGFloat statusBarHeight = [UIApplication statusBarHeight];
//    
//    [keyboardHookView addKeyboardNonpanningWithActionHander:^(CGRect keyboardFrameInViewRaw) {
//        CGSize deviceSize = [UIApplication currentSize];
//        CGRect keyboardFrameInView = [[YPAppDelegate me].window.rootViewController.view convertRect:keyboardFrameInViewRaw fromView:keyboardHookView];
//        
//        keyboardFrameInView.origin.y += statusBarHeight;
//        
//        if((keyboardFrameInView.origin.y+ keyboardFrameInView.size.height == deviceSize.height)||keyboardFrameInView.origin.y == deviceSize.height) {
//            
//            if(keyboardFrameInView.origin.y+ keyboardFrameInView.size.height == deviceSize.height) {
//                //when keyboard show
//                CGPoint margin = onlyChangeHeight ? CGPointMake(originFrame.origin.x,originFrame.origin.y) : CGPointMake(originFrame.origin.x,0);
//                CGSize size = onlyChangeHeight ? CGSizeMake(deviceSize.width-margin.x*2.f,originFrame.size.height - keyboardFrameInView.size.height) : CGSizeMake(deviceSize.width-margin.x*2.f,deviceSize.height-keyboardFrameInView.size.height-statusBarHeight);
//                [viewToResize setNewFrame: CGRectMake(margin.x, margin.y, size.width, size.height)];
//                
//            }
//            else {
//                //when keyboard hide
//                CGPoint margin = originFrame.origin;
//                CGSize size = CGSizeMake(deviceSize.width-margin.x*2.f,deviceSize.height-margin.y*2.f-statusBarHeight);
//                
//                [viewToResize setNewFrame: CGRectMake(margin.x, margin.y, size.width, size.height)];
//            }
//        }
//    }];
//}

#pragma mark - Timer on main queue
- (void) startMainTimer: (void (^)()) onTimeHander afterSeconds: (NSTimeInterval) seconds {
    if(_mainTimer) {
        [self stopMainTimer];
    }
    if (_mainTimer == NULL)
	{
		if (seconds <= 0.0)
		{
			// All timed reconnect attempts are disabled
			return;
		}
		
		_mainTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		
		dispatch_source_set_event_handler(_mainTimer, onTimeHander);
		
#if NEEDS_DISPATCH_RETAIN_RELEASE
		dispatch_source_t theMainTimer = _mainTimer;
		
		dispatch_source_set_cancel_handler(_mainTimer, ^{
			XMPPLogVerbose(@"dispatch_release(theMainTimer)");
			dispatch_release(theMainTimer);
		});
#endif
		
		dispatch_time_t startTime;
		startTime = dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC));
		
		dispatch_source_set_timer(_mainTimer, startTime, 0.0, 0.25);
		dispatch_resume(_mainTimer);
	}
}

- (BOOL) stopMainTimer {
    if (_mainTimer)
	{
		dispatch_source_cancel(_mainTimer);
		_mainTimer = NULL;
        return YES;
	}
    else {
        return NO;
    }
}

- (void) closeModal {
    [self closeModalAndPerformSelector:nil withObject:nil];
}

- (void) closeModalAndPerformSelector:(SEL) aSelector withObject: (id)object {
    if(self.window.rootViewController.modalViewController!=nil) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            if(aSelector!=nil) {
                [self performSelector:aSelector withObject:object];
            }
        }];
    }
}

@end
