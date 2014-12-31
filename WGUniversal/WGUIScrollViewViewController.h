//
//  WGUIScrollViewViewController.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-26.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGBaseViewController.h"

@interface WGUIScrollViewViewController : WGBaseViewController{

    UIScrollView *_scrollView;
    UIPageControl *_pageControl;

}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;

-(void)buildPageControl;
-(void)createPageControl;
@end
