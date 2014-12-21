//
//  WGUIImageView.h
//  WGUniversal
//
//  Created by 莹 申 on 14-10-28.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAKFontAwesome.h"

@interface WGUIImageView : UIImageView {
    FAKIcon *_iconFont;
    NSBundle *_bundle;
}

@property (nonatomic,strong) NSString *iconCode;
@property (nonatomic,strong) NSString *iconFontFilePath;
@property (nonatomic,strong) FAKIcon *iconFont;
@property (nonatomic,assign) CGFloat *iconSize;

@end
