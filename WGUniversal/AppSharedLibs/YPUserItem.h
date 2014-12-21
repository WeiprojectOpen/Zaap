//
//  KNSelectorItem.h
//  KNFBFriendSelectorDemo
//
//  Created by Kent Nguyen on 4/6/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol Userdelegate <NSObject>

@required
-(void)change:(NSString *)str;

@end

@interface YPUserItem : NSObject
@property (nonatomic,strong)id<Userdelegate>delegate;
@property (strong,nonatomic) NSString * displayValue;
@property (strong,nonatomic) NSString * sortValue;
@property (strong,nonatomic) NSString * selectValue;
@property (strong,nonatomic) NSString * detailValue;
@property (strong,nonatomic) NSString * imageUrl;
@property (strong,nonatomic) NSString * facebookId;
@property (nonatomic) int contactId;
@property (nonatomic) int userId;
@property (nonatomic) int tag;
@property (nonatomic) BOOL selected;

// Init with a simple value and no image
-(id)initWithDisplayValue:(NSString*)displayVal;

// Init with a display value that is different from actual value and with optional image
-(id)initWithDisplayValue:(NSString*)displayVal
              selectValue:(NSString*)selectVal
                 imageUrl:(NSString*)image;

// You can use these to sort items using [NSArray sortedArrayUsingSelector:]
// Refer to Facebook Friend selector example
- (NSComparisonResult) compareByDisplayValue:(YPUserItem*)other;
- (NSComparisonResult) compareBySelectedValue:(YPUserItem*)other;
- (NSComparisonResult) compareBySortValue:(YPUserItem*)other;

@end
