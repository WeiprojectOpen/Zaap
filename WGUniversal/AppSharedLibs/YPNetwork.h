//
//  YPNetwork.h
//  SharedLibs
//
//  Created by flannian on 10/1/13.
//  Copyright (c) 2013 pc2pp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPNetwork : NSObject

- (BOOL)isHttpHostReachable: (NSString *) domain;
- (BOOL)isInternetReachable;
- (BOOL)isInternetReachableWithoutMessage;
- (BOOL)isInternetReachableRaw: (BOOL) showAlert;

- (void) startNetworkRequestWithHint: (NSString *) hint;
- (void) endNetworkRequest;
- (void) endNetworkRequestWithHint: (NSString *) hint;

@end
