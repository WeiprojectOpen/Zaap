//
//  NSString+NSVerticalAlign.h
//  WPabout
//
//  Created by 莹 申 on 14-7-3.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NSVerticalTextAlignmentTop,
    NSVerticalTextAlignmentMiddle,
    NSVerticalTextAlignmentBottom
} NSVerticalTextAlignment;

@interface NSString (VerticalAlign)
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font verticalAlignment:(NSVerticalTextAlignment)vAlign;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode verticalAlignment:(NSVerticalTextAlignment)vAlign;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment verticalAlignment:(NSVerticalTextAlignment)vAlign;
@end
