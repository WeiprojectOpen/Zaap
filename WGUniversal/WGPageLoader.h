//
//  WGPageLoader.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WGPAGELOAD_DEBUG NO
#define MAS_SHORTHAND

#pragma mark - view的所处环境的类型
typedef enum {
    WGViewContainerTypeNormal = 0, // 容器为普通结构的View
    WGViewContainerTypeCell = 1, // 容器为表格或Collection中的单元格
    WGViewContainerTypeSectionHeader = 2, // 容器为表格Section的Header
    WGViewContainerTypeSectionFooter = 3,    // 容器为表格Section的Footer
    WGViewContainerTypeTableHeader = 4,
    WGViewContainerTypeTableFooter = 5
} WGViewContainerType;

@class WGBaseViewController;

@protocol WGPageLoaderDelegate;

@interface WGViewInfo : NSObject
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, retain) NSString *cName;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *cellpath;
@property (nonatomic, assign) WGBaseViewController *vc;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) UIView *bindView;
@property (nonatomic, assign) WGViewContainerType containerType;
@property (nonatomic, retain) NSIndexPath *indexpath;
@property (nonatomic, retain) NSMutableDictionary *properties;


@end

@protocol WGPageLoaderDelegate
//视图开始绑定
- (void) bindedWithViewController: (UIViewController *) vc;
@optional
//视图加载完成
- (void) viewControllerDidLoad: (UIViewController *) vc;
//视图开始显示
- (void) viewControllerDidAppear;
- (void) cellDidAppearWithIndexPath:(NSIndexPath *)indexpath  ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//单选结果回调
-(void) optionSelected: (id) value ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;
-(void) optionsSelected: (NSArray *) values ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//常规View的值
- (NSString *) valueForKey: (NSString *) key defaultValue: (id) defaultValue ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;
- (NSString *) valueForParam: (NSString *) paramName defaultValue: (id) defaultValue ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//Cell的值
-(id) valueForParam:(NSString *)paramName defaultValue: (id) defaultValue  forCellWithIndexPath:(NSIndexPath *)indexpath  ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;
-(id) valueForKey:(NSString *)key defaultValue: (id) defaultValue forCellWithIndexPath:(NSIndexPath *)indexpath  ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//Cell的Header的值
-(id) valueForParam:(NSString *)paramName defaultValue: (id) defaultValue forHeaderInSection:(NSInteger)section ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;
-(id) valueForKey:(NSString *)key defaultValue: (id) defaultValue forHeaderInSection:(NSInteger)section  ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//Cell的Footer的值
-(id) valueForParam:(NSString *)paramName defaultValue: (id) defaultValue forFooterInSection:(NSInteger)section ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;
-(id) valueForKey:(NSString *)key defaultValue: (id) defaultValue forFooterInSection:(NSInteger)section  ofView:(UIView *) view withViewInfo: (WGViewInfo *) wgViewInfo;

//Cell多样性的支持
- (NSString *) reuseIdentifierForCellAtIndexPath: (NSIndexPath *)indexPath defaultIdentifier: (NSString *) defaultIdentifier;

- (CGFloat) heightForCellAtIndexPath:(NSIndexPath *)indexPath senderInfo: (WGViewInfo *) senderInfo;
- (CGFloat) heightForHeaderInSection: (NSInteger)section senderInfo: (WGViewInfo *) senderInfo;
- (CGFloat) heightForFooterInSection: (NSInteger)section senderInfo: (WGViewInfo *) senderInfo;

-(void) cellSelectedWithIndexPath:(NSIndexPath *)indexpath senderInfo: (WGViewInfo *) senderInfo;



-(NSInteger)numberOfRowsInSection:(NSInteger)section InSenderWithInfo: (WGViewInfo *) senderInfo;
- (NSInteger)numberOfSectionsInSenderWithInfo: (WGViewInfo *) senderInfo;

-(void) headerRereshingInSenderWithInfo: (WGViewInfo *) senderInfo;
-(void) footerRereshingInSenderWithInfo: (WGViewInfo *) senderInfo;


-(UIView *) viewForFooterInSection:(NSInteger)section defaultView: (UIView *) footerView senderInfo: (WGViewInfo *) senderInfo;
-(UIView *) viewForHeaderInSection:(NSInteger)section defaultView: (UIView *) headerView senderInfo: (WGViewInfo *) senderInfo;

-(UIView *) viewForCellAtIndexPath:(NSIndexPath *)indexPath defaultView: (UIView *) cellView senderInfo: (WGViewInfo *) senderInfo;

# pragma mark 饼状图，柱状图
- (NSInteger) numberOfSlicesInChart:(WGViewInfo *) senderInfo;
- (CGFloat) valueForSliceAtIndex:(NSUInteger)index senderInfo: (WGViewInfo *) senderInfo;
- (NSString *) titleForSliceAtIndex:(NSUInteger)index senderInfo: (WGViewInfo *) senderInfo;
- (UIColor *) colorForSliceAtIndex:(NSUInteger)index senderInfo: (WGViewInfo *) senderInfo;

- (NSInteger)numberOfSlicesPresentedEveryTimeOfView:(UIView *) view senderInfo: (WGViewInfo *) senderInfo;
- (CGFloat)highestValueOfChart:(UIView *)view senderInfo: (WGViewInfo *) senderInfo;

- (NSString *) unitOfChart:(UIView *) view senderInfo: (WGViewInfo *) senderInfo;

# pragma mark 设置HTML文本
- (void) setHTML: (NSString *) html forView: (UIView *) view;

@end

@interface WGPageLoader : NSObject<UITextViewDelegate>

@property (nonatomic,assign) BOOL isFakeViewMode;
@property (nonatomic,strong) NSMutableArray *mediaPlayers;

- (CGFloat) fixRatio;

- (CGFloat)heightOfText:(NSString *) text font: (UIFont *) font
     withSuperviewWidth:(CGFloat)superviewWidth;
- (BOOL)isIOS7OrHigher;
- (BOOL)isIOS8OrHigher;
- (CGFloat) heightThatFitView: (UIView *) view;

+ (WGPageLoader *) getCurrentInstance;
-(UIViewController *)loadRootViewController: (NSString *) rootPlist;
-(UIViewController *)loadRootViewController: (NSString *) rootPlist bundle: (NSString *) bundleName;

-(UIViewController *)loadRootViewController: (NSString *) rootPlist bundle: (NSString *) bundleName pageid: (NSInteger) pageid;

-(UIViewController *) getViewControllerOfPage: (NSInteger) pageid;
-(UIViewController *) createUIViewControllerForPageId :(NSInteger )pageid;
-(UIViewController *) getSubviewControllerByPath:(NSString *)path inPage:(NSInteger) pageid;
- (UIView *) getSubviewByPath: (NSString *) subviewPath parentView: (UIView *) parentView;

- (UIViewController *) createWidgetUIViewController: (NSInteger) pageid;

-(id) getSubviewByPath:(NSString *)path inViewController:(UIViewController *) viewController;
-(id) getSubviewByPath:(NSString *)path andInPage:(NSInteger)pageid;    //或子元素
-(UITableView *) getTableviewByPath:(NSString *)path inViewController:(UIViewController *) viewController;
//-(UITableView *) getTableviewByPath:(NSString *)path andInPage:(NSInteger)pageid; //获得Tableview;
-(UIScrollView *) getScrollviewByPath:(NSString *)path inViewController:(UIViewController *) viewController;
//-(UIScrollView *) getScrollviewByPath:(NSString *)path andInPage:(NSInteger)pageid; //获得Scrollview;

-(UICollectionView *) getCollectionviewByPath:(NSString *)path inViewController:(UIViewController *) viewController;
//-(UICollectionView *) getCollectionviewByPath:(NSString *)path andInPage:(NSInteger)pageid; //获得Scrollview;
-(id) getEmbedControlByPath:(NSString *)path andInPage:(NSInteger)pageid;    //或子元素
-(void) replacePage:(NSInteger)fromPageid WithPage:(NSInteger) ToPageid; //替换页面

//设置UITableView类型元素的代理
- (void) setDelegate: (id<WGPageLoaderDelegate>) delegate forViewController: (UIViewController *) viewController;
- (void) setDelegate: (id<WGPageLoaderDelegate>) delegate forPageId: (NSInteger) pageid;
- (NSObject<WGPageLoaderDelegate> *) delegateForViewController: (UIViewController *) viewController;

- (NSInteger) getMenuPageId;
- (void) setMenuMainPage: (NSInteger) pageId;
- (BOOL) isParam: (NSString *) value;

//得到视图某个属性
- (id) valueForKey: (NSString *) key ofView: (UIView *) view;

- (NSInteger)numberOfSectionsDefaultOfView: (UIView *) view;
- (NSInteger)numberOfRowsInSectionDefault:(NSInteger)section ofView: (UIView *) view;

- (BOOL) isCellSelected: (UIView *) view;
-(void)handleTouchAction:(NSString *)touch andPageid:(NSString *)pageid andFromPageid:(NSString *)fromPageId sender:(UIView *)sender;
-(void)beginAnimation:(CFTimeInterval)dur andTransition:(UIViewAnimationTransition)transition sender:(UITapGestureRecognizer *)sender cache:(BOOL)cache;
-(void)showAnimation:(UIView *)view andViewController:(UIViewController*)vc sender:(UITapGestureRecognizer *)sender;
-(void)startAnimation;

- (void) foundToView: (UIView *) view inPath: (NSString *)path forParentView: (UIView *) parentView;
-(void)HandleOnShow:(WGBaseViewController *) wgVC;
-(void)HandleOnShowCell:(UIView *) view;

-(UIEdgeInsets)insetsForItem:(NSIndexPath *)indexPath;
- (CGSize)blockSizeForItem:(NSIndexPath *)indexPath;

# pragma mark 设置HTML文本
- (void) setHTML: (NSString *) html forView: (UIView *) view;

# pragma mark pushRoot

-(void) pushRoot: (UIViewController *) vc;

# pragma mark 旋转动画
- (void) startSpinView: (UIView *) view speed: (CGFloat) speed;
- (void) stopSpinView: (UIView *) view;

@end












