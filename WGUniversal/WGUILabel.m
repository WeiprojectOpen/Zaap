//
//  WGUILabel.m
//  WGUniversal
//
//  Created by AndyM on 14/10/21.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGUILabel.h"
#import "Masonry.h"

@implementation WGUILabel {

}

@synthesize verticalAlignment=_verticalAlignment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textNotSelected = nil;
        _textColorNotSelected = nil;
        _textSizeNotSelected = 0;
        self.verticalAlignment=VerticalAlignmentMiddle;
    }
    return self;
}
-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment=verticalAlignment;
    [self setNeedsDisplay];//重绘一下
}

-(void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    [self setNeedsDisplay];//重绘一下
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect=[super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch(self.verticalAlignment)
    {
        case VerticalAlignmentTop:
            textRect.origin.y=bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y=bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y=bounds.origin.y+bounds.size.height-textRect.size.height;
            break;
        default:
            textRect.origin.y=bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
    }
    return textRect;
}


- (void) setSelected:(BOOL)selected {
    if(_selected != selected) {
        NSLog(@"current text = %@",self.text);
//        if(_textNotSelected == nil) {
//            _textNotSelected = self.text;
//            _textColorNotSelected = self.textColor;
//            _textSizeNotSelected = self.font.pointSize;
//        }
        _selected = selected;
        [self setText:_selected && _textSelected!=nil  ? _textSelected : _textNotSelected];
        [self setTextColor:_selected && _textColorSelected!=nil ? _textColorSelected : _textColorNotSelected];
        [self setFont:[UIFont fontWithName:self.font.fontName size:_selected && _textSizeSelected > 0 ? _textSizeSelected : _textSizeNotSelected]];
        
        [self setNeedsDisplay];
    }
}
//
//- (void)layoutSubviews {
//    if(self.numberOfLines == 0) {
//        CGFloat height =  [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height;
//        
//        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, height);
//        
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(height)).priority(MASLayoutPriorityRequired);
//        }];
//    }
//    [super layoutSubviews];
//    
//}

-(void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect=[self textRectForBounds:UIEdgeInsetsInsetRect(rect, self.insets) limitedToNumberOfLines:self.numberOfLines];//重新计算位置
    [super drawTextInRect:actualRect];
}

@end