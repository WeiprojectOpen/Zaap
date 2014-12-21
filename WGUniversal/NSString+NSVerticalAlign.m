//
//  NSString+NSVerticalAlign.m
//  WPabout
//
//  Created by 莹 申 on 14-7-3.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "NSString+NSVerticalAlign.h"

@implementation NSString (NSVerticalAlign)
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }
    return [self drawInRect:rect withFont:font];
}
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode];
}
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }   
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
}
@end
