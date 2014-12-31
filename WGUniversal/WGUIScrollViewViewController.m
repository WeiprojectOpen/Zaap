//
//  WGUIScrollViewViewController.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-26.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGUIScrollViewViewController.h"
#import "Masonry.h"

@interface WGUIScrollViewViewController ()<UIScrollViewDelegate>

@end

@implementation WGUIScrollViewViewController


//字符串过滤掉非法字符替换为_
- (NSString *) pathToReuseIdentifier: (NSString *) path {
    return [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

-(void)buildScrollView{
    
   _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    _scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    [self.view addSubview:_scrollView];
    // Set the constraints for the scroll view and the image view.
    [_scrollView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.superview.top);
        make.left.equalTo(_scrollView.superview.left);
        make.width.equalTo(_scrollView.superview.width);
        make.height.equalTo(_scrollView.superview.height);
    }];
//    _scrollView =[[UIScrollView alloc]init];
    
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
//    //        _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if([self.view.layer.sublayers count] > 0) {
        ((CALayer *)[self.view.layer.sublayers firstObject]).frame = self.view.bounds;
    }
}
//-(CGRect)buildPage{
//
// 
//}

-(void)createPageControl{
    _scrollView.delegate = self;
    self.view.clipsToBounds = YES;
    CGRect rect = self.view.frame;
    rect.origin.y = 0;;
    rect.size.height = 30;
    
    if(_pageControl == nil){
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
    }
    _pageControl.hidesForSinglePage =NO;
    _pageControl.userInteractionEnabled = YES;
}

-(void)buildPageControl{
    _pageControl.numberOfPages = [self childViewControllers].count;
    _pageControl.currentPage = 0;
    
    [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];

    //[_pageControl removeFromSuperview];
    //[self.view addSubview:_pageControl];
    
    //NSLog(@"%@",_pageControl.superview);
    [self loadData];
    [self.view bringSubviewToFront:_pageControl];
}

- (void)changePage:(id)sender {
    
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width * _pageControl.currentPage, 0) animated:YES];
    
    UIViewController *vc = [[self childViewControllers] objectAtIndex:_pageControl.currentPage];
    
    [vc viewDidAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildScrollView];
    // Do any additional setup after loading the view.
}

//- (void)setDataource:(id<WGCycleScrollViewDatasource>)datasource
//{
//    _datasource = datasource;
//    [self reloadData];
//}
//
//- (void)reloadData
//{
//    _totalPages = [_datasource numberOfPages];
//    if (_totalPages == 0) {
//        return;
//    }
//    _pageControl.numberOfPages = _totalPages;
//    [self loadData];
//}

- (void)loadData
{
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
//    [self getDisplayImagesWithCurpage:_curPage];
    UIView *prevView = _scrollView;
    for (int i = 0; i < [self childViewControllers].count; i++) {
      
        UIViewController *subVc =[[self childViewControllers]objectAtIndex:i];
        UIView *v = subVc.view;
        v.frame = CGRectOffset(_scrollView.bounds, _scrollView.frame.size.width * i, 0);
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_scrollView addSubview:v];
        
        [v updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(prevView.top);
            if(prevView ==_scrollView) {
                make.left.equalTo(prevView.left);
            }
            else {
                make.left.equalTo(prevView.right);
            }
            //make.right.equalTo(v.superview).offset(padding.right);
            make.width.equalTo(v.superview.width);
            make.height.equalTo(v.superview.height);
        }];
        
        prevView = v;
    }
    
    [prevView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scrollView.right);
    }];
    
    //[_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}




//
//- (void)getDisplayImagesWithCurpage:(int)page {
//    
//    int pre = [self validPageValue:_curPage-1];
//    int last = [self validPageValue:_curPage+1];
//    
//    if (!_curViews) {
//        _curViews = [[NSMutableArray alloc] init];
//    }
//    
//    [_curViews removeAllObjects];
//    
//    [_curViews addObject:[_datasource pageAtIndex:pre]];
//    [_curViews addObject:[_datasource pageAtIndex:page]];
//    [_curViews addObject:[_datasource pageAtIndex:last]];
//}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = [self childViewControllers].count - 1;
    if(value == [self childViewControllers].count) value = 0;
    
    return value;
    
}

//- (void)handleTap:(UITapGestureRecognizer *)tap {
//    
//    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
//        [_delegate didClickPage:self atIndex:_curPage];
//    }
//    
//}
//
//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
//{
//    if (index == _curPage) {
//        [_curViews replaceObjectAtIndex:1 withObject:view];
//        for (int i = 0; i < 3; i++) {
//            UIView *v = [_curViews objectAtIndex:i];
//            v.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                        action:@selector(handleTap:)];
//            [v addGestureRecognizer:singleTap];
//            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
//            [_scrollView addSubview:v];
//        }
//    }
//}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (_pageControl !=nil) {
        int x = aScrollView.contentOffset.x;
        
        if(x >= _pageControl.currentPage * self.view.frame.size.width && x>0) {
            if(_pageControl.currentPage < _pageControl.numberOfPages) {
                _pageControl.currentPage += 1;
                
            }
        }
        else {
            if(_pageControl.currentPage > 0) {
                _pageControl.currentPage -= 1;
            }
        }
    
        [self changePage:aScrollView];
        }
    
}





#pragma mark UIScrollViewDelegate
//只要滚动了就会触发
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//{
//    //    NSLog(@" scrollViewDidScroll");
//    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//}
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDragging");
}
//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    NSLog(@"scrollViewDidEndDragging");
}
//将开始降速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDecelerating");
}
//减速停止了时执行，手触摸时执行执行
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewDidEndDecelerating");
//}
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
}


////设置放大缩小的视图，要是uiscrollview的subview
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
//{
//    NSLog(@"viewForZoomingInScrollView");
//    return viewA;
//}
////完成放大缩小时调用
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
//{
//    viewA.frame=CGRectMake(50,0,100,400);
//    NSLog(@"scale between minimum and maximum. called after any 'bounce' animations");
//}// scale between minimum and maximum. called after any 'bounce' animations


//如果你不是完全滚动到滚轴视图的顶部，你可以轻点状态栏，那个可视的滚轴视图会一直滚动到顶部，那是默认行为，你可以通过该方法返回NO来关闭它
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewShouldScrollToTop");
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewDidScrollToTop");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


//-(void)viewDidAppear:(BOOL)animated{
//
// 
//    self.hidesBottomBarWhenPushed = NO;
//    
//
//    [super viewDidAppear:animated];
//    
//    
//
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//
//     self.hidesBottomBarWhenPushed = NO;
//     [super viewDidAppear:animated];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
