//
//  WGPieChart.m
//  WGUniversal
//
//  Created by 莹 申 on 14-12-1.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGPieChart.h"
#import "UIView+WGViewInfo.h"
#import "WGBaseViewController.h"
#import "UIColor+HexString.h"
#import "WGPageLoader-internal.h"

@implementation WGPieChart {
    WGPageLoader *_pageLoader;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageLoader = [WGPageLoader getCurrentInstance];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return [_pageLoader numberOfSlicesInChart:pieChart];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [_pageLoader view:pieChart valueForSliceAtIndex:index];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [_pageLoader view:pieChart colorForSliceAtIndex:index];
}

@end
