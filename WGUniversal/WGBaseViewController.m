//
//  WGCollectionView.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGPlist.h"
#import "WGPageLoader.h"
#import "WGPageLoader-internal.h"
#import "UIColor+HexString.h"
#import "UIView+WGViewInfo.h"
#import "WGBaseViewController.h"


@interface WGBaseViewController () {
    UITextField *_activeField;
    
    NSIndexPath *_lastSelectedIndexPath;
    
    BOOL _keybaordNotificationAdded;
}

@end


@implementation WGBaseViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    [self.navigationController setNavigationBarHidden:YES];
    _keybaordNotificationAdded = NO;
    //[self registerForKeyboardNotifications];
}

- (UIView *) getContainerView: (int) tag forChildViewController: (UIViewController *) childController{
    tag = tag + 8080;
    
    UIView *childVCContainerView = [self.view viewWithTag:tag];
    
    if(childVCContainerView == nil) {
        childVCContainerView = [[UIView alloc] initWithFrame:childController.view.frame];
        childVCContainerView.backgroundColor =[UIColor clearColor];
        childVCContainerView.autoresizingMask = childController.view.autoresizingMask;
        childController.view.frame = childController.view.bounds;
        childController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        childVCContainerView.tag = tag;
        
        [self.view addSubview:childVCContainerView];
    }
    
    return childVCContainerView;
}

- (void) addChildViewControllerToContainer: (UIViewController *)childController addToView: (BOOL) addToView{
    int i=0;
    BOOL found = NO;
    for (UIViewController *childVC in self.childViewControllers) {
        if(childVC == childController) {
            UIView *childVCContainerView = [self getContainerView:i forChildViewController:childController];
            if(addToView) {
                childController.view.frame = childVCContainerView.bounds;
                [childVCContainerView addSubview:childController.view];
                childVCContainerView.hidden =NO;
            }
            else {
                childVCContainerView.hidden =YES;
            }
            found = YES;
            break;
        }
        i++;
    }
}

- (void) removeChildViewControllerFromContainer: (UIViewController *)childController {
    childController.view.superview.hidden =YES;
    [childController.view removeFromSuperview];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if([self.view.layer.sublayers count] > 0) {
        ((CALayer *)[self.view.layer.sublayers firstObject]).frame = self.view.bounds;
    }
}

//字符串过滤掉非法字符替换为_
- (NSString *) pathToReuseIdentifier: (NSString *) path {
    return [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (NSString *) pathFromReuseIdentifier: (NSString *) identifier {
    return [identifier stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
}

- (NSString *) pathIdentifier {
    return [self pathToReuseIdentifier:self.view.wgInfo.path];
}


#pragma mark - 处理delegate的设置
- (void) setWgDelegate:(id<WGPageLoaderDelegate>)wgDelegate {
    _wgDelegate = wgDelegate;
    if([self.childViewControllers count]>0) {
        for (WGBaseViewController *vc in self.childViewControllers) {
            vc.wgDelegate = _wgDelegate;
        }
    }
}


#pragma mark- cellForItemAtIndexPath 
//http://my.oschina.net/CarlHuang/blog/139191 参考

- (UIView *) headerOrFooterView: (BOOL) isHeader{
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    NSString *headerPath = [NSString stringWithFormat:@"%@/%@",self.view.wgInfo.path, isHeader ? @"header" : @"footer"];
    id headerInfo = [_plist objectFromPath: headerPath];
    
    if(headerInfo != nil) {
        UIView *headerView =[[UIView alloc] initWithFrame:CGRectZero];
        
        WGViewInfo *wgInfo = [WGViewInfo new];
        wgInfo.pageId = self.view.wgInfo.pageId;
        wgInfo.path = headerPath;
        wgInfo.vc = self;
        wgInfo.cName = self.wgName;
        wgInfo.containerType = isHeader ? WGViewContainerTypeTableHeader : WGViewContainerTypeTableFooter;
        wgInfo.bindView = nil;
        
        
        wgInfo.properties = [_plist objectFromPath: headerPath];
        headerView.wgInfo = wgInfo;
        [pageLoader applyPropertiesToView: headerView properties:wgInfo.properties   inPath: headerPath forParentView:nil];
        [pageLoader loadViewTreeForPlist:_plist andViewPath:headerPath forParent:headerView];
        return headerView;
    }
    
    return nil;
}

- (NSString *) realpathForTableItemWithContainerType: (WGViewContainerType) containerType indexPath:(NSIndexPath *) indexPath section: (NSInteger)section key: (NSString *) key {
    UIView *contentOrHeaderFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.view.wgInfo.path, key];
    NSLog(@"view.wgInfo.path = %@",self.view.wgInfo.path);
    WGViewInfo *wgInfo = [WGViewInfo new];
    wgInfo.pageId = self.view.wgInfo.pageId;
    wgInfo.path = path;
    wgInfo.indexpath = indexPath;
    wgInfo.section = section;
    wgInfo.containerType = containerType;
    wgInfo.cName = self.wgName;
    wgInfo.vc = self;
    // wgInfo.properties = [self.view.wgInfo.properties objectForKey:@"cell"];
    contentOrHeaderFooterView.wgInfo = wgInfo;
    NSDictionary *properties = [self propertiesForCellAtIndexPath:indexPath contentView:contentOrHeaderFooterView];
    contentOrHeaderFooterView.wgInfo.properties = properties;
    
    //[view.wgInfo.vc.plist objectFromPath: [NSString stringWithFormat:@"%@/%@", @"dataSelected", paramName]];
    NSString *realPath = [self realpathForTableItemKey:key contentView:contentOrHeaderFooterView];
    if(realPath!=nil) {
        return realPath;
    }
    else {
        return NO;
    }
}

- (void) updateWgInfoForCell:(UIView *) contentOrHeaderFooterView containerType: (WGViewContainerType) containerType indexPath:(NSIndexPath *) indexPath section: (NSInteger)section {
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    contentOrHeaderFooterView.wgInfo.indexpath = indexPath;
    contentOrHeaderFooterView.wgInfo.section = section;
    
    NSArray *subviews = [contentOrHeaderFooterView subviews];
    
    for (UIView *subview in subviews) {
        if(subview.wgInfo != nil) {
            [self updateWgInfoForCell: subview containerType: containerType indexPath: indexPath section:section];
        }
    }
}

- (UIView *) fakeView {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
}


#pragma mark -- 计算高度

- (BOOL) fillCellOrHeaderFooterView:(UIView *) contentOrHeaderFooterView containerType: (WGViewContainerType) containerType indexPath:(NSIndexPath *) indexPath section: (NSInteger)section key: (NSString *) key {
    
    contentOrHeaderFooterView.backgroundColor = [UIColor clearColor];
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.view.wgInfo.path, key];
    NSLog(@"view.wgInfo.path = %@",self.view.wgInfo.path);
    WGViewInfo *wgInfo = [WGViewInfo new];
    wgInfo.pageId = self.view.wgInfo.pageId;
    wgInfo.path = path;
    wgInfo.indexpath = indexPath;
    wgInfo.section = section;
    wgInfo.containerType = containerType;
    wgInfo.cName = self.wgName;
    wgInfo.vc = self;
    // wgInfo.properties = [self.view.wgInfo.properties objectForKey:@"cell"];
    contentOrHeaderFooterView.wgInfo = wgInfo;
    NSDictionary *properties = [self propertiesForCellAtIndexPath:indexPath contentView:contentOrHeaderFooterView];
    contentOrHeaderFooterView.wgInfo.properties = properties;
    
    //[view.wgInfo.vc.plist objectFromPath: [NSString stringWithFormat:@"%@/%@", @"dataSelected", paramName]];
    NSString *realPath = [self realpathForTableItemKey:key contentView:contentOrHeaderFooterView];
    if(realPath!=nil) {
        contentOrHeaderFooterView.wgInfo.path = realPath;
        
        
        [pageLoader applyPropertiesToView: contentOrHeaderFooterView properties: properties inPath: path forParentView:nil];
        [pageLoader loadViewTreeForPlist:_plist andViewPath:realPath forParent:contentOrHeaderFooterView];
        return YES;
    }
    else {
        return NO;
    }
}

-(UIView *) viewForSection:(NSInteger)section isHeader: (BOOL) isHeader {
    UIView *headerView = [self fakeView];
    if([self fillCellOrHeaderFooterView:headerView containerType:isHeader ? WGViewContainerTypeSectionHeader : WGViewContainerTypeSectionFooter indexPath:nil section:section key:isHeader ? @"sectionHeader" : @"sectionFooter"]) {
        return headerView;
    }
    else {
        return nil;
    }
}


-(UIView *) viewForHeaderInSection:(NSInteger)section {
    return [self viewForSection:section isHeader:YES];
}

-(UIView *) viewForFooterInSection:(NSInteger)section {
    return [self viewForSection:section isHeader:NO];
}

- (NSString *) reuseIdentifierForCellAtIndexPath: (NSIndexPath *)indexPath {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    //保留支持多种不同类型Cell的能力
    //NSString *path = [NSString stringWithFormat:@"%@/cell",self.view.wgInfo.path];
     NSString *path = [self realpathForTableItemWithContainerType: WGViewContainerTypeCell indexPath:indexPath section:-1 key:@"cell"];
    NSString *identifier = [self pathToReuseIdentifier: path];
    if(wgCellDelegate != nil && ([(NSObject *)wgCellDelegate respondsToSelector:@selector(reuseIdentifierForCellAtIndexPath:defaultIdentifier:)])) {
        identifier = [wgCellDelegate reuseIdentifierForCellAtIndexPath: indexPath defaultIdentifier: identifier];
    }
    return identifier;
}

-(NSDictionary *) propertiesForCellAtIndexPath: (NSIndexPath *) indexPath contentView: (UIView *) contentView {
    
    NSDictionary *properties = [self.view.wgInfo.properties objectForKey:@"cell"];
    if(properties == nil) {
        WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
        NSString *name = [pageLoader defaultValueForParam:@"name" key:@"name" ofView:contentView];
        if(name !=nil) {
            return [self.view.wgInfo.properties objectForKey:name];
        }
        else {
            return nil;
        }
    }
    else {
        return properties;
    }
}

-(NSString *) realpathForTableItemKey: (NSString *) key contentView: (UIView *) contentView {
    NSDictionary *properties = [self.view.wgInfo.properties objectForKey:key];
    if(properties == nil) {
        WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
        //NSString *name = [pageLoader defaultValueForParam:@"name" key:@"name" ofView:contentView];
        NSString *name = [pageLoader valueForKey:@"name" ofView:contentView];
        if(name !=nil) {
            return [NSString stringWithFormat:@"%@/%@",self.view.wgInfo.path, name];
        }
        else {
            return nil;
        }
    }
    else {
        return [NSString stringWithFormat:@"%@/%@",self.view.wgInfo.path, key];
    }
}

#pragma mark --- 绑定子视图

-(void) bindSubviewToCellContentView:(UIView *) contentView
                 cellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    
    if(contentView.wgInfo == nil) {
        if(_keybaordNotificationAdded) {
            [self addHideKeyboardEventToCell:contentView];
        }
        //此时也需要计算高度
        [self fillCellOrHeaderFooterView:contentView containerType:WGViewContainerTypeCell indexPath:indexPath section:-1 key:@"cell"];
    }
    else if(self.cellParams != nil) {
        [self updateContentView:contentView atIndexPath:indexPath];
    }
    
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate != nil && ([(NSObject *)wgCellDelegate respondsToSelector:@selector(viewForCellAtIndexPath:defaultView:senderInfo:)])) {
        contentView = [wgCellDelegate viewForCellAtIndexPath:indexPath defaultView: contentView senderInfo: self.view.wgInfo];
    }
}


- (CGFloat) heightForHeaderInSection:(NSInteger)section {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(heightForHeaderInSection:senderInfo:)])) {
        UIView *headerView = [self viewForHeaderInSection:section];
        if(headerView == nil) return 0;
        
        return [[WGPageLoader getCurrentInstance] heightThatFitView:headerView];
    }
    else {
        return [wgCellDelegate heightForHeaderInSection: section senderInfo:self.view.wgInfo];
    }
}

- (CGFloat) heightForFooterInSection:(NSInteger)section {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(heightForHeaderInSection:senderInfo:)])) {
        UIView *footerView = [self viewForFooterInSection:section];
        if(footerView == nil) return 0;
        
        return [[WGPageLoader getCurrentInstance] heightThatFitView:footerView];
    }
    else {
        return [wgCellDelegate heightForFooterInSection: section senderInfo:self.view.wgInfo];
    }
}


- (NSString *) keyForIndexPath: (NSIndexPath *) indexPath {
    return [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (NSString *) keyForSection: (NSInteger) section {
    return [NSString stringWithFormat:@"s_%ld", (long)section];
}

- (CGFloat) heightForCellAtIndexPath:(NSIndexPath *)indexPath {
   // - (CGFloat) heightForCellAtIndexPath:(NSIndexPath *)indexPath senderInfo: (WGViewInfo *) senderInfo
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(heightForCellAtIndexPath:senderInfo:)])) {
        UIView *fakeCellView = [self fakeView];
        
        WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
        pageLoader.isFakeViewMode = YES;
        [self fillCellOrHeaderFooterView:fakeCellView containerType:WGViewContainerTypeCell indexPath:indexPath section:-1 key:@"cell"];
        pageLoader.isFakeViewMode = NO;
        return fakeCellView == nil ? 0 : [pageLoader heightThatFitView:fakeCellView];
    }
    else {
        return [wgCellDelegate heightForCellAtIndexPath: indexPath senderInfo:self.view.wgInfo];
    }
}

- (void)headerRereshing {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    NSLog(@"headerRereshing wgInfo = %@", self.view.wgInfo);
    if(wgCellDelegate != nil && [(NSObject *)wgCellDelegate respondsToSelector:@selector(headerRereshingInSenderWithInfo:)]) {
        [wgCellDelegate headerRereshingInSenderWithInfo:self.view.wgInfo];
    }
}

- (void)footerRereshing {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate != nil && [(NSObject *)wgCellDelegate respondsToSelector:@selector(footerRereshingInSenderWithInfo:)]) {
        [wgCellDelegate footerRereshingInSenderWithInfo:self.view.wgInfo];
    }
}




- (UIEdgeInsets)insetsForItemIndexPath:(NSIndexPath *)indexPath{
    
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];

//    return UIEdgeInsetsMake(2, 2, 2, 2);
    
    return  [pageLoader insetsForItem:indexPath];
    
}


- (CGSize)blockSizeForItemIndexPath:(NSIndexPath *)indexPath{
    
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    
   
    
    
//    
//    if(indexPath.row >= numberOfRowsInSection) {
//        NSLog(@"Asking for index paths of non-existant cells!! %d from %d cells", indexPath.row, self.numbers.count);
//    }
//    
//    CGFloat width = [[self.numberWidths objectAtIndex:indexPath.row] floatValue];
//    CGFloat height = [[self.numberHeights objectAtIndex:indexPath.row] floatValue];
//
//    CGFloat width =  [[[pageLoader blockSizeForItem:indexPath.row].width ]floatValue ];
//    
    
    

    return [pageLoader blockSizeForItem:indexPath ];
    
    
    
    
//     return CGSizeMake(width, height);
    
}



- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    NSLog(@"numberOfRowsInSection = %ld",(long)self.view.wgInfo.pageId);
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
    if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(numberOfRowsInSection:InSenderWithInfo:)])) {
        return [self numberOfRowsInSectionDefault:section];
    }
    else {
        return [wgCellDelegate numberOfRowsInSection: section InSenderWithInfo:self.view.wgInfo];
    }
}

- (NSInteger)numberOfRowsInSectionDefault:(NSInteger)section {
    NSString *path = [NSString stringWithFormat:@"data/%@/cell/%ld", self.wgName, (long)section];
    
    NSLog(@"self.wgName = %@",self.wgName);
    NSArray *array = [self.plist objectFromPath:path];
    return array == nil ? 0 : [array count];
}

- (NSInteger)numberOfSections {
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
       NSLog(@"numberOfSections self.wgName = %@",self.view.wgInfo);
    if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(numberOfSectionsInSenderWithInfo:)])) {
        //NSString *path = [NSString stringWithFormat:@"data/%@/sectionHeader", self.wgName];
        return [self numberOfSectionsDefault];
    }
    else {
        return [wgCellDelegate numberOfSectionsInSenderWithInfo: self.view.wgInfo];
    }
}

- (NSInteger)numberOfSectionsDefault {
    NSString *path = [NSString stringWithFormat:@"data/%@/cell", self.wgName];
    NSLog(@"numberOfSectionsDefault self.wgName = %@",self.wgName);
    NSArray *array = [self.plist objectFromPath:path];
    return array == nil ? 0 : [array count];
}

- (void) applyPropertiesToView: (UIView *) view key: (NSString *) key path: (NSString *) path atIndexPath:(NSIndexPath *)indexPath{
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    

    view.wgInfo.indexpath = indexPath;
    id value = [pageLoader valueForKey:key ofView: view];
    
    if([key isEqualToString:@"title"]) {
        NSLog(@"applyPropertiesToView title = %@, indexpath = %@", value, indexPath);
    }
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:value,key, nil];
    
    
    
    [pageLoader applyPropertiesToView:view properties:dict inPath:path forParentView:nil];
}

-(void) updateContentView: (UIView *) contentView atIndexPath:(NSIndexPath *)indexPath{

    if(self.cellParams != nil) {
        if(contentView == nil) {
            if([self isKindOfClass:[WGTableViewViewController class]]){
                UITableViewController *tableVC = (UITableViewController *) self;
                UITableViewCell * cell = (UITableViewCell *)[tableVC.tableView cellForRowAtIndexPath:indexPath];
                contentView = cell.contentView;
            }
            else {
                UICollectionViewController *tableVC = (UICollectionViewController *) self;
                UICollectionViewCell * cell = (UICollectionViewCell *)[tableVC.collectionView cellForItemAtIndexPath:indexPath];
                contentView = cell.contentView;
            }
        }
        
        WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
        
        [self updateWgInfoForCell:contentView containerType: WGViewContainerTypeCell indexPath: indexPath section: -1];
        for (NSString* keyPath in _cellParams) {
            NSLog(@"keyPath = %@",keyPath);
            NSDictionary *property = [_cellParams objectForKey:keyPath];
            NSString *path = [property objectForKey:@"path"];
            NSString *key = [property objectForKey:@"key"];
            if([contentView.wgInfo.path isEqualToString:path]) {
                [self applyPropertiesToView:contentView key:key path:path atIndexPath:indexPath];
            }
            
            UIView *subview = [pageLoader getSubviewByPath:path parentView:contentView];
            
            if(subview != nil) {
                [self applyPropertiesToView:subview key:key path:path atIndexPath:indexPath];
            }
            
//            for (UIView *subview in contentView.subviews) {
//                if([subview.wgInfo.path isEqualToString:path]) {
//                    [self applyPropertiesToView:subview key:key path:path atIndexPath:indexPath];
//                }
//            }
            
        }
    }
}

- (void) didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellParams != nil) {
        if([self isKindOfClass:[WGTableViewViewController class]]){
            UITableViewController *tableVC = (UITableViewController *) self;
            [tableVC.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            UICollectionViewController *tableVC = (UICollectionViewController *) self;
            [tableVC.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject: indexPath]];
        }

        //[self updateContentView:nil atIndexPath:indexPath];
        if(_keybaordNotificationAdded) {
            [self hideKeyboard:nil];
        }
    }
}

//刚显示出来
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc viewDidAppear:animated];
    }
    
     WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    [pageLoader HandleOnShow:self];

}

//UITableViewCell每个的变化
-(void) willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    [pageLoader HandleOnShowCell:cell.contentView];

    
}

//UICollectionViewCell每个的变化
- (void) didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
 
    NSLog(@"111");
    
}




//UICollectionView被选中时调用的方法
-(void) didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
    
    if(self.cellParams != nil) {
        if(_lastSelectedIndexPath == nil || (_lastSelectedIndexPath.section != indexPath.section || _lastSelectedIndexPath.row != indexPath.row)) {
            [self updateContentView:nil atIndexPath:indexPath];
            _lastSelectedIndexPath = indexPath;
        }
    }
    NSObject<WGPageLoaderDelegate> *wgCellDelegate = self.view.wgInfo.vc.wgDelegate;
        if(wgCellDelegate == nil || (![(NSObject *)wgCellDelegate respondsToSelector:@selector(cellSelectedWithIndexPath:senderInfo:)])) {
            return;
            for (NSDictionary* property in _cellParams) {
                
                NSString *propertyKey = [property objectForKey:@"key"];
            if([propertyKey isEqualToString:@"touch"]) {
            
    //            NSLog(@"要跳转了。第%lu",indexPath.row);
                WGPageLoader *pageLoader = [WGPageLoader getCurrentInstance];
                
                NSString *pagePath = [NSString stringWithFormat: @"%@/%ld/%@", _basePath, (long)indexPath.row, [property objectForKey:@"value"]];
                
                NSNumber *pageNamed = [_plist objectFromPath:pagePath];
                
                UIViewController *vc =[pageLoader createUIViewControllerForPageId:[pageNamed integerValue]];
                
                NSLog(@"要跳转了。第%@  pageNamed=%@",pagePath,pageNamed);
                
                [self.navigationController pushViewController:vc animated:YES];
                
                }
                
            }
        }
        else {
            [wgCellDelegate cellSelectedWithIndexPath:indexPath senderInfo:self.view.wgInfo];
        }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(_activeField != textField) {
        _activeField = textField;
        [self showActiveFieldInTableView];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

- (void) showActiveFieldInTableView {
    if([self isKindOfClass:[WGTableViewViewController class]]){
        UITableViewController *tableVC = (UITableViewController *) self;
        [tableVC.tableView scrollToRowAtIndexPath:_activeField.wgInfo.indexpath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    else {
        UICollectionViewController *tableVC = (UICollectionViewController *) self;
        //
    }
}


- (void)autoResizeMeOnKeyboardNotification:(NSNotification*)aNotification isShown: (BOOL) isShown{

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if([self isKindOfClass:[WGTableViewViewController class]]){
        NSString *autosizeForKeyboard = [self.view.wgInfo.properties objectForKey:@"autoresize-for-keyboard"];
        UITableViewController *tableVC = (UITableViewController *) self;
        if(isShown) {
            [tableVC.tableView setContentInset:UIEdgeInsetsMake(0, 0, kbSize.height - [autosizeForKeyboard floatValue], 0)];
            [self performSelector:@selector(showActiveFieldInTableView) withObject:nil afterDelay:0.01];
        }
        else {
            [tableVC.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
//    
//
//    
//    UIView *subview =  self.currentSubPageVc !=nil ? self.currentSubPageVc.view : self.view;
//    
//    NSLog(@"autoResizeMeOnKeyboardNotification = %@", subview.wgInfo);
//    //subview.autoresizingMask = UIViewAutoresizingNone;
//    CGRect frame = subview.frame;
//    
//    NSLog(@"autoResizeMeOnKeyboardNotification frame = %@, keyboard size = %@",NSStringFromCGRect(subview.frame), NSStringFromCGSize(kbSize));
//    //subview.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//    subview.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, isShown ? frame.size.height-kbSize.height - 50 : frame.size.height+kbSize.height);
//    
//    NSLog(@"autoResizeMeOnKeyboardNotification frame = %@",NSStringFromCGRect(subview.frame));
//    
//    //subview.backgroundColor = [UIColor blackColor];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    [self autoResizeMeOnKeyboardNotification:aNotification isShown:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self autoResizeMeOnKeyboardNotification:aNotification isShown:NO];
}

-(void)hideKeyboard:(UITapGestureRecognizer*)tap{
    
    [_activeField resignFirstResponder];
}

- (void) addHideKeyboardEventToCell: (UIView *) contentView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    // tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [contentView addGestureRecognizer:tapGestureRecognizer];
}

- (void)registerForKeyboardNotifications
{
    if(_keybaordNotificationAdded) return;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    _keybaordNotificationAdded = YES;
    
    
}

@end
