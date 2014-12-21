//
//  UIColor+HexString.m
//  YMG
//
//  Created by Flannian on 10/7/12.
//  Copyright (c) 2012 MateMedia. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor(HexString)

+ (CGFloat) colorComponentFromEx: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFromEx: colorString start: 0 length: 1];
            green = [self colorComponentFromEx: colorString start: 1 length: 1];
            blue  = [self colorComponentFromEx: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFromEx: colorString start: 0 length: 1];
            red   = [self colorComponentFromEx: colorString start: 1 length: 1];
            green = [self colorComponentFromEx: colorString start: 2 length: 1];
            blue  = [self colorComponentFromEx: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFromEx: colorString start: 0 length: 2];
            green = [self colorComponentFromEx: colorString start: 2 length: 2];
            blue  = [self colorComponentFromEx: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFromEx: colorString start: 0 length: 2];
            red   = [self colorComponentFromEx: colorString start: 2 length: 2];
            green = [self colorComponentFromEx: colorString start: 4 length: 2];
            blue  = [self colorComponentFromEx: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


@end
