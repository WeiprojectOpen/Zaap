//
//  YPNetwork.m
//  SharedLibs
//
//  Created by flannian on 10/1/13.
//  Copyright (c) 2013 pc2pp.com. All rights reserved.
//

#import "YPNetwork.h"
#import "Reachability.h"
#import "YPAppDelegate.h"

@interface YPNetwork() {
    Reachability *_internetReach;
}
@end

@implementation YPNetwork

- (id) init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        _internetReach = [Reachability reachabilityForInternetConnection];
        [_internetReach startNotifier];
        
    }
    return self;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    if(curReach == _internetReach) {
        [[YPAppDelegate me] recheckInternetReachable];
    }
}

- (BOOL) isHttpHostReachable: (NSString *) domain {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",domain]];
    // NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:url] mutableCopy];
    [request setHTTPMethod:@"HEAD"];
    NSURLResponse *response = nil;
    NSError *error=nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
    return httpStatus == 200;
}

- (BOOL) isInternetReachableRaw: (BOOL) showAlert {
    
    NetworkStatus netStatus = [_internetReach currentReachabilityStatus];
    BOOL connectionRequired= [_internetReach connectionRequired];
    
    BOOL isReachable = !(connectionRequired || NotReachable==netStatus);
    
    if((!isReachable) && showAlert) {
        [[YPAppDelegate me].msg showNeedNetworkConnectionMessage];
    }
    return isReachable;
}

- (BOOL) isInternetReachableWithoutMessage {
    return [self isInternetReachableRaw: NO];
}

- (BOOL) isInternetReachable {
    return [self isInternetReachableRaw: YES];
}

- (void) startNetworkRequestWithHint: (NSString *) hint {
    [[YPAppDelegate me].msg showProgressHUDWithMessage:hint == nil ? @"加载中..." : hint afterDelay:0.01 key: @"network"];
}

- (void) endNetworkRequest {
    [[YPAppDelegate me].msg hideProgressHUD:YES withKey:@"network"];
}

- (void) endNetworkRequestWithHint: (NSString *) hint {
    [[YPAppDelegate me].msg showProgressHUDCompleteMessage:hint];
}

@end
