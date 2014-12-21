//
//  WGUIImageView.m
//  WGUniversal
//
//  Created by 莹 申 on 14-10-28.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGUIImageView.h"

@implementation WGUIImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSMutableDictionary *_iconFontPaths;

- (void) updateIcon {
    if(_iconFont == nil) {
        _iconFontPaths
    }
    
    if(_iconFont != nil) {
        self.image = [_iconFont imageWithSize:self.frame.size];
        [self setNeedsDisplay];
    }
}

- (void) setIconFontFilePath:(NSString *)iconFontFilePath {
    if([_iconFontPaths objectForKey:iconFontFilePath]==nil) {
        [_iconFontPaths setObject:iconFontFilePath forKey:iconFontFilePath];
        [FAKIcon registerIconFontWithURL: [_bundle URLForResource:iconFontFilePath withExtension:nil]];
    }
    
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    if(_iconFont != nil) {
        [self updateIcon];
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [FAKIcon registerIconFontWithURL: [_bundle URLForResource:@"./fonts/zocial-regular-webfont" withExtension:@"ttf"]];
//        });
//
//        [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
//        return [cogIcon imageWithSize:CGSizeMake(20, 20)];
    }
}

- (void) setIconCode:(NSString *)iconCode {
    if(_iconCode != iconCode) {
        _iconCode = iconCode;
        
        //FAKZocial *cogIcon = [self iconWithCode:@"\u00E3" size:size];;
    }
}


- (id) initWithBundle: (NSBundle *) bundle {
    self = [super initWithFrame:CGRectZero];
    if(self != nil) {
        _bundle = bundle;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _iconFontPaths = [NSMutableDictionary dictionary];
        });
    }
    return self;
}

@end
