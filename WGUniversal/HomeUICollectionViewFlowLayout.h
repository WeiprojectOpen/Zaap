//
//  HomeUICollectionViewFlowLayout.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-7.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Plist;

@interface HomeUICollectionViewFlowLayout : UICollectionViewFlowLayout



- (instancetype)initWithPath: (NSString *) path andPlist: (Plist *) plist;

@end
