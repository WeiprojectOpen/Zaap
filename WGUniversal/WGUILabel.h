//
//  WGUILabel.h
//  WGUniversal
//
//  Created by AndyM on 14/10/21.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop=0,
    VerticalAlignmentMiddle,//default
    VerticalAlignmentBottom,
    
}VerticalAlignment;

@interface WGUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
    UIEdgeInsets _insets;
}

@property(nonatomic)VerticalAlignment verticalAlignment;
@property(nonatomic)UIEdgeInsets  insets;
@property(nonatomic)NSString *textSelected;
@property(nonatomic)UIColor *textColorSelected;
@property(nonatomic, assign)CGFloat textSizeSelected;

@property(nonatomic)NSString *textNotSelected;
@property(nonatomic)UIColor *textColorNotSelected;
@property(nonatomic, assign)CGFloat textSizeNotSelected;

@property(nonatomic, assign)BOOL selected;

@end

