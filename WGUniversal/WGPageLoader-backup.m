//
//  WGPageLoader.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGPageLoader.h"
#import "WGPageLoader-internal.h"
#import "WGBaseViewController.h"
#import "UIColor+HexString.h"
#import "UIScrollView+MJRefresh.h"
#import "DDMenuController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+WGViewInfo.h"

@implementation WGViewInfo {
    
}

@end
@implementation WGPageLoader {
    int _tagCount;
    NSMutableDictionary *_cellDelegates;
    NSInteger _menuMainPageId;
}

#pragma mark - 获取PageLoader唯一实例

static WGPageLoader *pageLoader;
+ (WGPageLoader *) getCurrentInstance {
    if(pageLoader == nil) {
        pageLoader = [[WGPageLoader alloc] init];
    }
    return pageLoader;
}

#pragma mark - 设置和获取页面代理

- (void) setCellDelegate: (id<WGPageLoaderDelegate>) delegate forPageId: (NSInteger) pageid {
    if(_cellDelegates == nil) _cellDelegates = [[NSMutableDictionary alloc] init];
    [_cellDelegates setObject:delegate forKey:[NSString stringWithFormat: @"page%u", pageid]];
}

- (NSObject <WGPageLoaderDelegate>*) cellDelegateForPageId: (NSInteger) pageId {
    return [_cellDelegates objectForKey:[NSString stringWithFormat: @"page%u", pageId]];
}

#pragma mark - 1. 加载主视图控制器，支持tabbar和menu两种方式

- (UIViewController *) loadRootViewController: (NSString *) rootPlist {
    
    _appPlist =[[Plist alloc] initWithPlistFile:rootPlist];
    NSString *rootViewType = [_appPlist objectFromPath:@"type"];
    
    if([rootViewType isEqualToString:@"tabbar"]) {
        NSArray *tabArray = [_appPlist objectFromPath:rootViewType];
        return [self createTabBarControllerWithArray: tabArray];
    }
    else if ([rootViewType isEqualToString:@"menu"]) {
        NSDictionary *dict =[_appPlist objectFromPath:rootViewType];
        return [self createMenuUIViewController:dict];
    }
    
    return nil;
}

#pragma mark - 2.1 从plist中读取参数并创建TabBar

- (UITabBarController *) createTabBarControllerWithArray:(NSArray *) tabArray {
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tabDict in tabArray) {
        //确定第几个
        NSNumber *pageid = [tabDict objectForKey:@"pageid"];
        
        UIViewController *vc = [self getViewControllerOfPage:[pageid integerValue]];
        
        //创建UINavigationController
        UINavigationController *nav = [self createUINativationControllerWithVC:vc
                                                                    andTabDict:tabDict];
        [controllers addObject:nav];
    }
    
    [tbc setViewControllers:controllers];
    return tbc;
}

#pragma mark - 2.2 从plist中读取参数并创建Menu

- (UIViewController *) createMenuUIViewController: (NSDictionary *) dict{
    
    NSNumber *menuPageid = [dict objectForKey:@"menuPageid"];
    NSNumber *mainPageid = [dict objectForKey:@"mainPageid"];
    
    UIViewController *menuVC = [self getViewControllerOfPage:[menuPageid integerValue]];
    UIViewController *mainVC = [self getViewControllerOfPage:[mainPageid integerValue]];
    
    _menuMainPageId = [mainPageid integerValue];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    
    rootController.leftViewController = menuVC;
    
    return rootController;
}

#pragma mark - 3 根据页面id获取视图控制器（不存在则创建）

-(WGBaseViewController *)getViewControllerOfPage:(NSInteger)pageid{
    WGBaseViewController * vc = [_pages objectForKey:[NSString stringWithFormat: @"page%u", pageid]];
    if (vc == nil) {
        vc = [self createUIViewControllerForPageId :pageid];
    }
    return vc;
}

#pragma mark - 4.读取createUIViewControllerForPageId 隐藏

- (WGBaseViewController *) createUIViewControllerForPageId :(NSInteger )pageid {
    
    //所有的要跳转的plistNamed
    NSString *plistNamed = [self.appPlist objectFromPath:[NSString stringWithFormat:@"pages/%u/page", pageid]];
    
    self.currentPagePlistNamed = [NSString stringWithFormat:@"pages/%@",plistNamed];
    self.currentPageId = pageid;
    
    //通用currentPageVC
    WGBaseViewController *vc =[[WGBaseViewController alloc] init];
    
    
    self.currentPageVC = vc;
    
    //通用plist
    self.currentPagePlist = [[Plist alloc] initWithPlistFile: self.currentPagePlistNamed];
    
    //view 中加载plist树
    UIView *view =[self loadViewTreeForPlist:_currentPagePlist andViewPath:nil forParent:nil];
    
    vc.view =view;
    
    //设置root视图的wgInfo
    WGViewInfo *wgInfo = [WGViewInfo new];
    wgInfo.pageId = self.currentPageId;
    vc.view.wgInfo = wgInfo;
    
    if(_pages ==nil){_pages = [NSMutableDictionary new];}
    
    //缓存页面，用于@selector(getViewControllerOfPage:)再次获取
    [_pages setObject:vc forKey: [NSString stringWithFormat: @"page%u", pageid]];

    return vc;
}


#pragma mark - 动态数据的支持 - 获取plist中的变量数据
- (id) defaultValueForParam:(NSString *) paramName ofView: (UIView *) view {
    
    switch (view.wgInfo.containerType) {
        case WGViewContainerTypeNormal:
            return [self.currentPagePlist objectFromPath: [NSString stringWithFormat:@"params/%@", paramName]];
            break;
        case WGViewContainerTypeCell:
            return [self.currentPagePlist objectFromPath: [NSString stringWithFormat:@"params/%@/%d/%d/%@", view.wgInfo.name, view.wgInfo.indexpath.section, view.wgInfo.indexpath.row, paramName]];
            break;
        case WGViewContainerTypeSectionHeader:
        case WGViewContainerTypeSectionFooter:
            return [self.currentPagePlist objectFromPath: [NSString stringWithFormat:@"params/%@/%d/%@", view.wgInfo.name, view.wgInfo.indexpath.section, paramName]];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 动态数据的支持 - 获取plist中的固定数据
- (id) defaultValueForKey:(NSString *) key ofView: (UIView *) view {
    if(view.wgInfo.properties == nil) return nil;
    id value =[view.wgInfo.properties objectForKey:key];
    return value;
}

#pragma mark - 动态数据的支持 - 获取参数化数据
- (id) maybeValueOfParam:(id) value key: (NSString *)key ofView: (UIView *) view {
    if(value == nil) return nil;
    
    if([value isKindOfClass:[NSString class]]){
        if([self isDynamicProperty:value]) {
            NSString *paramName = [value stringByReplacingOccurrencesOfString:@"@" withString:@""];
            value = [self defaultValueForParam:paramName ofView:view];
            NSObject<WGPageLoaderDelegate> *wgPageLoaderDelegate = [self delegateForPageId :self.currentPageId];
            if(wgPageLoaderDelegate != nil) {
                //二次取值 之一
                if([wgPageLoaderDelegate respondsToSelector:@selector(valueForParam:defaultValue:ofView:withViewInfo:)]) {
                    value = [wgPageLoaderDelegate valueForParam:paramName defaultValue: value ofView: view withViewInfo: view.wgInfo];
                    switch (view.wgInfo.containerType) {
                        case WGViewContainerTypeNormal:
                            break;
                        case WGViewContainerTypeCell:
                            //二次取值 之二
                            if([wgPageLoaderDelegate respondsToSelector:@selector(valueForParam:defaultValue:forCellWithIndexPath:ofView:withViewInfo:)]) {
                                value = [wgPageLoaderDelegate valueForParam:paramName defaultValue: value forCellWithIndexPath:view.wgInfo.indexpath  ofView: view withViewInfo: view.wgInfo];
                            }
                            break;
                        case WGViewContainerTypeSectionHeader:
                            //二次取值 之二
                            if([wgPageLoaderDelegate respondsToSelector:@selector(valueForParam:defaultValue:forHeaderInSection:ofView:withViewInfo:)]) {
                                value = [wgPageLoaderDelegate valueForParam:paramName defaultValue: value forHeaderInSection:view.wgInfo.section  ofView: view withViewInfo: view.wgInfo];
                            }
                            break;
                        case WGViewContainerTypeSectionFooter:
                            //二次取值 之二
                            if([wgPageLoaderDelegate respondsToSelector:@selector(valueForParam:defaultValue:forFooterInSection:ofView:withViewInfo:)]) {
                                value = [wgPageLoaderDelegate valueForParam:paramName defaultValue: value forFooterInSection:view.wgInfo.section  ofView: view withViewInfo: view.wgInfo];
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            
            //如果不存在，则添加params
            if(view.wgInfo.params == nil) {view.wgInfo.params = [NSMutableDictionary dictionary];}
            if([view.wgInfo.params objectForKey:paramName] == nil ) {
                [view.wgInfo.params setObject:paramName forKey:key];
            }
        }
    }
    return value;
}


#pragma mark - 动态数据的支持
- (id) valueForKey: (NSString *) key ofView: (UIView *) view {
    NSObject<WGPageLoaderDelegate> *wgPageLoaderDelegate = [self delegateForPageId :self.currentPageId];
    if(wgPageLoaderDelegate == nil) {
        //获取plist中的变量数据
        return [self maybeValueOfParam:[self defaultValueForKey:key ofView: view] key:key ofView:view];
    }
    else {
        //二次取值 之一
        if([wgPageLoaderDelegate respondsToSelector:@selector(valueForKey:defaultValue:ofView:withViewInfo:)]) {
            id value = [self defaultValueForKey:key ofView: view];
            value = [wgPageLoaderDelegate valueForKey:key defaultValue:value  ofView: view withViewInfo: view.wgInfo];
            switch (view.wgInfo.containerType) {
                case WGViewContainerTypeNormal:
                    return [self maybeValueOfParam:value key:key ofView:view];
                    break;
                case WGViewContainerTypeCell:
                    //二次取值 之二
                    if([wgPageLoaderDelegate respondsToSelector:@selector(valueForKey:defaultValue:forCellWithIndexPath:ofView:withViewInfo:)]) {
                        value = [wgPageLoaderDelegate valueForKey:key defaultValue: value forCellWithIndexPath:view.wgInfo.indexpath  ofView: view withViewInfo: view.wgInfo];
                    }
                    return [self maybeValueOfParam:value key: key ofView:view];
                    break;
                case WGViewContainerTypeSectionHeader:
                    //二次取值 之二
                    if([wgPageLoaderDelegate respondsToSelector:@selector(valueForKey:defaultValue:forHeaderInSection:ofView:withViewInfo:)]) {
                        value = [wgPageLoaderDelegate valueForKey:key defaultValue: value forHeaderInSection:view.wgInfo.section  ofView: view withViewInfo: view.wgInfo];
                    }
                    return [self maybeValueOfParam:value key: key ofView:view];
                    break;
                case WGViewContainerTypeSectionFooter:
                    //二次取值 之二
                    if([wgPageLoaderDelegate respondsToSelector:@selector(valueForKey:defaultValue:forFooterInSection:ofView:withViewInfo:)]) {
                        value = [wgPageLoaderDelegate valueForKey:key defaultValue: value forFooterInSection:view.wgInfo.section  ofView: view withViewInfo: view.wgInfo];
                    }
                    return [self maybeValueOfParam:value key: key
                                            ofView:view];
                    break;
                default:
                    break;
            }
        }
        else {
            return [self maybeValueOfParam:[self defaultValueForKey:key ofView: view] key:key ofView:view];
        }
    }
}

#pragma mark- 通用的绑定UIView的信息
- (void) bindWGInfoToView: (UIView *) view properties: (NSDictionary *) subviewOption inPath: (NSString *)path  parentView:(UIView *) parentView{
    WGViewInfo *wgInfo = [WGViewInfo new];
    wgInfo.pageId = self.currentPageId;
    if((parentView !=nil) && (parentView.wgInfo != nil)) {
        wgInfo.cellpath = parentView.wgInfo.cellpath;
        wgInfo.section = parentView.wgInfo.section;
        wgInfo.containerType = parentView.wgInfo.containerType;
        wgInfo.indexpath = parentView.wgInfo.indexpath;
    }
    else {
        wgInfo.containerType = WGViewContainerTypeNormal;
    }
    wgInfo.path = path;
    wgInfo.properties = [NSMutableDictionary dictionaryWithDictionary:subviewOption];
    
    view.wgInfo = wgInfo;
    CGRect frame = CGRectFromString([subviewOption objectForKey:@"frame"]);
    view.frame =frame;
}


#pragma mark- 创建WGCollectionViewController
- (WGCollectionViewController *) createCollectionViewControllerForProperties: (NSDictionary *) subviewOption inPath: (NSString *)path parentView: (UIView *) parentView{
    
    WGCollectionViewController *colVC =[[WGCollectionViewController alloc] init];
    [self bindWGInfoToView: colVC.view properties: subviewOption inPath: path  parentView: parentView];
    return colVC;
}

#pragma mark- 创建WGTableViewViexwController

- (WGTableViewViewController *) createTableViewControllerForProperties: (NSDictionary *) subviewOption inPath: (NSString *)path parentView: (UIView *) parentView {
    
    WGTableViewViewController *tableVC =[[WGTableViewViewController alloc] init];
    [self bindWGInfoToView: tableVC.view properties: subviewOption inPath: path  parentView: parentView];
    return tableVC;
}

#pragma mark- 创建WGUIScrollViewViewController

- (WGUIScrollViewViewController *) createScrollViewControllerForProperties: (NSDictionary *) subviewOption inPath: (NSString *)path parentView: (UIView *) parentView {
    
    WGUIScrollViewViewController *scrollVC =[[WGUIScrollViewViewController alloc] init];
    [self bindWGInfoToView: scrollVC.view properties: subviewOption inPath: path  parentView: parentView];
    return scrollVC;
}

#pragma mark- 6.判断type createViewFromDictionary 总控制

- (UIView *) createViewFromDictionary: (NSDictionary*) subviewOption atPath: (NSString *) path  forParent:(UIView *) parentView{
    
    _tagCount = _tagCount+1;
    CGRect frame = CGRectFromString([subviewOption objectForKey:@"frame"]);
    
    NSString *type = [subviewOption objectForKey:@"type"];
    UIView *view = nil;
//    NSLog(@"type = %@",type );
    
    if ([type isEqualToString:@"collection"]) {
        //@"pages/HomeVC"
        //从Home页中创建WGCollectionViewController
        WGCollectionViewController *vc = [self createCollectionViewControllerForProperties:subviewOption inPath:path parentView:parentView];
        
        NSString *colorWithHexString =[subviewOption objectForKey:@"background-color"];
       // NSLog(@"colorWithHexString = %@",colorWithHexString);
//
        if(colorWithHexString != nil) vc.view.backgroundColor =[UIColor colorWithHexString:colorWithHexString];
        
        if(self.currentPageVC.PathedSubViews==nil){
            self.currentPageVC.PathedSubViews = [[NSMutableDictionary alloc] init];
        }
        [self.currentPageVC.PathedSubViews setValue: vc.collectionView forKey: [NSString stringWithFormat:@"%@/collectionview", path]];
        
        
        
        [self.currentPageVC addChildViewController:vc];
        vc.view.tag = _tagCount;
        view = vc.view;
    }
    else if ([type isEqualToString:@"tableview"]) {
        //@"pages/HomeVC"
        //从Home页中创建WGCollectionViewController
        WGTableViewViewController *vc = [self createTableViewController:[NSString stringWithFormat:@"%@",self.currentPagePlistNamed] andPath:path];
        
        NSDictionary *cell = [subviewOption objectForKey:@"cell"];
        NSArray *cellSubviews = [cell objectForKey:@"subviews"];
        //扫描dictionary，得到Cell模板中子view的动态属性
        vc.cellProperties = [self scanCellPropertiesFromSubviews: cellSubviews basePath: path];
        
        
        for (NSString *key in subviewOption) {
            
            //             NSLog(@"%@---%@",key,[subviewOption objectForKey:key]);
            
            id property = [subviewOption objectForKey:key];
            if([property isKindOfClass:[NSString class]] && [self isDynamicProperty:property]) {
                NSMutableDictionary *p = [NSMutableDictionary dictionary];
                [p setObject:key forKey:@"key"];
                [p setObject:[property stringByReplacingOccurrencesOfString:@"@" withString:@""] forKey:@"value"];
                [(NSMutableArray *)vc.cellProperties addObject:p];
            }
        }
        
        //        NSLog(@"vc.cellProperties = %@",vc.cellProperties);
        // HomeCollectionView
        vc.basePath = [cell objectForKey:@"collection"];
        //        NSLog(@" ============%@", [subviewOption objectForKey:@"collection"]);
        
        vc.view.frame = frame;
        //if(_cellDelegates !=nil)
        //    vc.wgCellDelegate = [_cellDelegates objectForKey:[NSString stringWithFormat: @"page%u", self.currentPageId]];
		NSString *colorWithHexString =[subviewOption objectForKey:@"background-color"];
        // NSLog(@"colorWithHexString = %@",colorWithHexString);
        //
        if(colorWithHexString != nil){
            
            vc.view.backgroundColor =[UIColor colorWithHexString:colorWithHexString];
        }
        
        if(self.currentPageVC.PathedSubViews==nil){
            self.currentPageVC.PathedSubViews = [[NSMutableDictionary alloc] init];
        }
        [self.currentPageVC.PathedSubViews setValue: vc.tableView forKey: [NSString stringWithFormat:@"%@/tableview", path]];
        
        NSNumber *headerRefresh =[subviewOption objectForKey:@"headerRefresh"];
        if((headerRefresh != nil) && [headerRefresh boolValue]) {
            [vc.tableView addHeaderWithTarget:vc action:@selector(headerRereshing)];
        }
        
        //#warning 自动刷新(一进入程序就下拉刷新)
        //[tableView headerBeginRefreshing];
        
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        NSNumber *footerRefresh =[subviewOption objectForKey:@"footerRefresh"];
        if((footerRefresh != nil) && [footerRefresh boolValue]) {
            [vc.tableView addFooterWithTarget:vc action:@selector(footerRereshing)];
        }
        
        [self.currentPageVC addChildViewController:vc];
        vc.view.tag = _tagCount;
        view = vc.view;
    }
    
    else if ([type isEqualToString:@"scrollview"]) {
        //@"pages/HomeVC"
        //从Home页中创建WGCollectionViewController
        WGTableViewViewController *vc = [self createTableViewController:[NSString stringWithFormat:@"%@",self.currentPagePlistNamed] andPath:path];
        
        NSDictionary *cell = [subviewOption objectForKey:@"cell"];
        NSArray *cellSubviews = [cell objectForKey:@"subviews"];
        //扫描dictionary，得到Cell模板中子view的动态属性
        vc.cellProperties = [self scanCellPropertiesFromSubviews: cellSubviews basePath: path];
        
        
        for (NSString *key in subviewOption) {
            
            //             NSLog(@"%@---%@",key,[subviewOption objectForKey:key]);
            
            id property = [subviewOption objectForKey:key];
            if([property isKindOfClass:[NSString class]] && [self isDynamicProperty:property]) {
                NSMutableDictionary *p = [NSMutableDictionary dictionary];
                [p setObject:key forKey:@"key"];
                [p setObject:[property stringByReplacingOccurrencesOfString:@"@" withString:@""] forKey:@"value"];
                [(NSMutableArray *)vc.cellProperties addObject:p];
            }
        }
        
        //        NSLog(@"vc.cellProperties = %@",vc.cellProperties);
        // HomeCollectionView
        vc.basePath = [cell objectForKey:@"collection"];
    
        [self.currentPageVC addChildViewController:vc];
        view = vc.view;
    }
    else if([type isEqualToString:@"image"]) {
        view = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    else if ([type isEqualToString:@"label"]){
        view = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    else if ([type isEqualToString:@"button"]){
        view =[UIButton buttonWithType:UIButtonTypeCustom];
    }
    else if ([type isEqualToString:@"textField"]){
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        //[textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        view = textField;
    }
    else if ([type isEqualToString:@"password"]){
        UITextField *textField = [[UITextField alloc] initWithFrame:frame];
        //[textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        textField.secureTextEntry = YES; //是否以密码形式显示
        view = textField;
    }
    else if ([type isEqualToString:@"video"]){
        MPMoviePlayerController *moviewPlayer=[[MPMoviePlayerController alloc]init];
        view = moviewPlayer.view;
        if(self.currentPageVC.embebControls ==nil) self.currentPageVC.embebControls = [NSMutableDictionary new];
        [self.currentPageVC.embebControls setObject:moviewPlayer forKey:path];
        [moviewPlayer shouldAutoplay];
        //播放
        [moviewPlayer play];
    }
    else {
        view = [[UIView alloc]initWithFrame:CGRectZero];
    }
    
    [self bindWGInfoToView:view properties:subviewOption inPath:path parentView:parentView];
    
    [self applyPropertiesToView:view properties:subviewOption inPath:path parentView:parentView];
    
    return view;
}



#pragma mark- 6.3从subviewOption里面获取key

- (id) getViewProperty: (NSString *) key fromDictionary: (NSDictionary*) subviewOption{
    
    id property = [subviewOption objectForKey:key];
    
//     NSLog(@"property ===========%@",property);
    //     property =@imageName
    
    if([self isDynamicProperty:property]) {
        
        return nil;
    }
    else {
        return property;
    }
}



#pragma mark- 6.3.1判断是否在里面有特殊符号 @
- (BOOL) isDynamicProperty: (NSString *) value {
    return ([value length] > 0 && [value characterAtIndex:0] == '@');
}

#pragma mark- 6.1扫描dictionary，得到Cell模板中子view的动态属性
//扫描dictionary，得到Cell模板中子view的动态属性
- (NSMutableArray *) scanCellPropertiesFromSubviews: (NSArray*) subviews  basePath:(NSString *) path{
    NSMutableArray *dynamicProperties = [NSMutableArray array];
    [self scanCellPropertiesFromSubviews:subviews properties:dynamicProperties basePath: path];
    return dynamicProperties;
    
}

#pragma mark- 6.2scanCellPropertiesFromSubviews

- (void) scanCellPropertiesFromSubviews: (NSArray*) subviews properties: (NSMutableArray *) dynamicProperties  basePath:(NSString *) path{
    
    for (NSDictionary *subview in subviews) {
        NSArray *subviewsInSubview = [subview objectForKey:@"subviews"];
        if(subviewsInSubview == nil) {
            for (NSString *key in [subview allKeys]) {
                id property = [subview objectForKey:key];
                if([property isKindOfClass:[NSString class]] && [self isDynamicProperty:property]) {
                    NSMutableDictionary *p = [NSMutableDictionary dictionary];
                    [p setObject:[NSString stringWithFormat:@"%@/%@", path, key] forKey:@"path"];
                    [p setObject:key forKey:@"key"];
                    [p setObject:[property stringByReplacingOccurrencesOfString:@"@" withString:@""] forKey:@"value"];
                    [p setObject:[subview objectForKey:@"type"] forKey:@"type"];
                    [dynamicProperties addObject:p];
                }
            }
        }
        else {
            [self scanCellPropertiesFromSubviews:subviewsInSubview properties:dynamicProperties basePath: [NSString stringWithFormat:@"%@/subviews", path]];
        }
    }
}

#pragma mark- 5.创建loadViewTreeForPlist isCell

- (UIView *)loadViewTreeForPlist:(Plist *)plist andViewPath:(NSString *)path forParent: (UIView *) view {
    NSString *rootViewsName = @"subviews";
    NSString *framePath = path==nil ? @"frame" : [NSString stringWithFormat:@"%@/frame",path];
    CGRect frame = CGRectFromString([plist objectFromPath:framePath]);
    NSString *subviewPath = path==nil ? rootViewsName : [NSString stringWithFormat:@"%@/%@",path,rootViewsName];
    NSArray *subviews = [plist objectFromPath: subviewPath];
    
    if(view == nil) {
        view =[[UIView alloc] initWithFrame:frame];
    }
    int i = 0;
    
    for (NSDictionary* subviewOption in subviews) {
        
        //view 中是否包含view
        NSArray *subviewsInSubview = [subviewOption objectForKey:@"subviews"];
                NSLog(@" subviewsInSubview ---%@",subviewsInSubview);
        
        UIView *subview = nil;
        //subviewInSubviewPath = views/0/cell/3
        NSString *subviewInSubviewPath = [NSString stringWithFormat:@"%@/%d",subviewPath, i];
        
        if(subviewsInSubview == nil) {
            
            subview = [self createViewFromDictionary:subviewOption atPath: subviewInSubviewPath forParent:view];
            //添加路径到字典
            if(self.currentPageVC.PathedSubViews==nil){
                self.currentPageVC.PathedSubViews = [[NSMutableDictionary alloc] init];
            }
            [self.currentPageVC.PathedSubViews setValue: subview forKey: subviewInSubviewPath];
        }
        else {
            //子View中又包含子view
            //递归调用
            subview = [self loadViewTreeForPlist:plist andViewPath:subviewInSubviewPath forParent:view];
        }
       
        
        [view addSubview:subview];
        i++;
    }
    
    return view;
}


//#pragma mark- ？？？
/*- (UIView *) createCollectionViewCellSubviewFromTemplatePath:(NSString *)tplPath andDataPath:(NSString *) dataPath {
    
    UIView *subview = [self loadViewTreeForPlist:self.currentPagePlist andViewPath:tplPath];
    return subview;
}*/




- (NSInteger) getMenuPageId {
    return _menuMainPageId;
}

- (void) setMenuMainPage: (NSInteger) pageId {
    [self replacePage:_menuMainPageId WithPage:pageId];
    _menuMainPageId = pageId;
}






#pragma mark-通过pageid，获取path


-(id)getSubviewByPath:(NSString *)path andInPage:(NSInteger)pageid{


    WGBaseViewController * vc =(WGBaseViewController *)[self getViewControllerOfPage:pageid];
    
    id subview =[vc.PathedSubViews objectForKey: path];

    return subview;
}

-(id) getEmbedControlByPath:(NSString *)path andInPage:(NSInteger)pageid {
    WGBaseViewController * vc =(WGBaseViewController *)[self getViewControllerOfPage:pageid];
    
    id control =[vc.embebControls objectForKey: path];
    
    return control;
}


-(UIButton *)getButtonFromPath:(NSString *)path andInPage:(NSInteger)pageid{
    
    WGBaseViewController * vc =(WGBaseViewController *)[self getViewControllerOfPage:pageid];

    UIButton *btn =[vc.PathedSubViews objectForKey: path];
    
//    if (vc != nil) {
//        
//        NSLog(@"通过KEY找到的value是: %@",vc);
//        
//    }else{
//        
////        vc = [self createUIViewControllerForPageId :pageid];
//        
//      vc =  [vc.PathedSubViews objectForKey: path];
//        
//    }
    
    return btn;
}

-(void) replacePage:(NSInteger)fromPageid WithPage:(NSInteger) ToPageid{

    WGBaseViewController *oldPage = (WGBaseViewController *)[pageLoader getViewControllerOfPage:fromPageid];
    
    WGBaseViewController *newPage = (WGBaseViewController *)[pageLoader getViewControllerOfPage:ToPageid];
    
     // Replace the current view controller
     NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:oldPage.navigationController.viewControllers];
     [viewControllers removeLastObject];
     [viewControllers addObject:newPage];
     [oldPage.navigationController setViewControllers:viewControllers animated:YES];
}


#pragma mark- 3.从tabDict中创建UINativationController添加到vc
- (UINavigationController*) createUINativationControllerWithVC: (UIViewController *)vc andTabDict: (NSDictionary *) tabDict {
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.image=[UIImage imageNamed:[tabDict objectForKey:@"tabarImage"]];
    vc.title =  [tabDict objectForKey:@"tabarTitle"];
    
//    [nav setNavigationBarHidden:YES animated:YES];
    return nav;
}

#pragma mark - 位置尺寸自适应的支持。
- (void) applyAutoresizeMask: (CGRect) anchor ToView: (UIView *)view {
    
    UIViewAutoresizing resize = UIViewAutoresizingNone;
    if(anchor.origin.x == 1.f && anchor.size.width == 1.f) {
        resize = resize | UIViewAutoresizingFlexibleWidth;
    }
    else if(anchor.origin.x == 1.f && anchor.size.width == 0.f) {
        resize = resize | UIViewAutoresizingFlexibleRightMargin;
    }
    else if(anchor.origin.x == 0.f && anchor.size.width == 1.f) {
        resize = resize | UIViewAutoresizingFlexibleLeftMargin;
    }
    else if(anchor.origin.x == 0.5f && anchor.size.width == 0.5f) {
        resize = resize | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    if(anchor.origin.y == 1.f && anchor.size.height == 1.f) {
        resize = resize | UIViewAutoresizingFlexibleHeight;
    }
    else if(anchor.origin.y == 1.f && anchor.size.height == 0.f) {
        resize = resize | UIViewAutoresizingFlexibleBottomMargin;
    }
    else if(anchor.origin.y == 0.f && anchor.size.height == 1.f) {
        resize = resize | UIViewAutoresizingFlexibleTopMargin;
    }
    else if(anchor.origin.y == 0.5f && anchor.size.height == 0.5f) {
        resize = resize | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    [view setAutoresizingMask:resize];
}


#pragma mark - 对各种类型的UIView进行统一处理。
- (void) applyPropertiesToView: (UIView *) view properties: (NSDictionary *) subviewOption inPath: (NSString *)path  parentView:(UIView *) parentView {
    
    //所有UIView都有的属性
    NSString *anchorStr = [subviewOption objectForKey:@"anchor"];
    if(anchorStr !=nil) {
        CGRect anchor = CGRectFromString(anchorStr);
        [self applyAutoresizeMask: anchor ToView: view];
    }
    
    NSNumber *tag = [subviewOption objectForKey:@"tag"];
    if(tag !=nil) {
        view.tag = [tag intValue];
    }
    
    //背景色
    NSString *colorWithHexString = [self valueForKey:@"color" ofView:view];
    if(colorWithHexString!=nil) {
        view.backgroundColor =[UIColor colorWithHexString:colorWithHexString];
    }
    
    //图片专有的属性
    if([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)view;
        //图片地址
        NSString *src = [self valueForKey:@"src" ofView:imgView];
        
        if(src!=nil) {
            imgView.image = [UIImage imageNamed:src];
        }
    }
    
    //按钮专有的属性
    else if([view isKindOfClass:[UIButton class]]) {
        UIButton *btnView = (UIButton *)view;
        //背景图片地址
        NSString *backgroundImage = [self valueForKey:@"background-image" ofView:btnView];
        
        if(backgroundImage!=nil) {
            [btnView setImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
        }
        
        //文字显示的支持
        NSString *title = [self valueForKey:@"title" ofView:btnView];
        if(title!=nil) {
            [btnView setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
        }
    }
    
    //按钮专有的属性
    else if([view isKindOfClass:[UIButton class]]) {
        UIButton *btnView = (UIButton *)view;
        //背景图片地址
        NSString *backgroundImage = [self valueForKey:@"background-image" ofView:btnView];
        
        if(backgroundImage!=nil) {
            [btnView setImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
        }
        
        //文字显示的支持
        NSString *title = [self valueForKey:@"title" ofView:btnView];
        if(title!=nil) {
            [btnView setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
        }
    }
    
    //输入框专有的属性
    else if([view isKindOfClass:[UITextField class]]) {
        UITextField *textfieldView = (UITextField *)view;
        //占位文字显示的支持
        NSString *title = [self valueForKey:@"placeholder" ofView:textfieldView];
        if(title!=nil) {
            textfieldView.placeholder = [NSString stringWithFormat:@"%@",title];
        }
    }
    
    //Label标签专有的属性
    else if([view isKindOfClass:[UILabel class]]) {
        UILabel *labelView = (UILabel *)view;
        //文字显示的支持
        NSString *title = [self valueForKey:@"title" ofView:labelView];
        if(title!=nil) {
            labelView.text = [NSString stringWithFormat:@"%@",title];
        }
        
        //文字颜色的支持
        NSString *textColor = [self valueForKey:@"textColor" ofView:labelView];
        if(textColor!=nil) {
            labelView.textColor = [UIColor colorWithHexString:textColor];
        }
        
        //字体大小的支持
        NSString *textfont = [self valueForKey:@"textFont" ofView:labelView];
        if(textfont!=nil) {
            labelView.font =[UIFont systemFontOfSize:[textfont floatValue]];
        }
        
        //文字对齐方式的支持
        NSString *textAlignment = [self valueForKey:@"textAlignment" ofView:labelView];
        if ([textAlignment isEqualToString:@"center"]){
            labelView.textAlignment = NSTextAlignmentCenter;
        }else if ([textAlignment isEqualToString:@"right"]){
            labelView.textAlignment = NSTextAlignmentRight;
        }else{
            labelView.textAlignment = NSTextAlignmentLeft;
        }
        
        
    }
    
    //所有Scrollview都有的属性
    else if([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        //顶部refresh，下拉
        NSNumber *headerRefresh = [self valueForKey:@"headerRefresh" ofView:scrollView];
        if((headerRefresh != nil) && [headerRefresh boolValue]) {
            [scrollView addHeaderWithTarget:self.currentPageVC action:@selector(headerRereshing)];
        }
        
        //#warning 自动刷新(一进入程序就下拉刷新)
        //[tableView headerBeginRefreshing];
        
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        NSNumber *footerRefresh =[self valueForKey:@"footerRefresh" ofView:scrollView];
        if((footerRefresh != nil) && [footerRefresh boolValue]) {
            [scrollView addFooterWithTarget:self.currentPageVC action:@selector(footerRereshing)];
        }
    }
    
    
}

@end
