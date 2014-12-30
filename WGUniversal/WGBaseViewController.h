//
//  WGCollectionViewControler.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGPlist.h"
#import "WGPageLoader.h"

@interface WGBaseViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{

}

@property (nonatomic,strong) NSMutableDictionary *cellParams;
@property (nonatomic,strong) NSMutableDictionary *headerParams;
@property (nonatomic,strong) NSMutableDictionary *footerParams;
@property (nonatomic,strong) NSString *wgName;
@property (nonatomic,strong) NSString *basePath;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) Plist *plist;
@property (nonatomic,assign) WGBaseViewController *currentSubPageVc;
@property (nonatomic,strong) id<WGPageLoaderDelegate> wgDelegate;
@property (nonatomic, strong) NSMutableDictionary *embebControls;

@property (nonatomic,strong)NSMutableDictionary *PathedSubViews;

- (void) didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void) didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *) pathToReuseIdentifier: (NSString *) path;
- (NSString *) pathFromReuseIdentifier: (NSString *) identifier;
- (void) bindSubviewToCellContentView:(UIView *) contentView
       cellForItemAtIndexPath:(NSIndexPath *) indexPath;
- (CGFloat) heightForCellAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

- (UIEdgeInsets)insetsForItemIndexPath:(NSIndexPath *)indexPath;
- (CGSize)blockSizeForItemIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsDefault;
- (NSInteger)numberOfRowsInSectionDefault:(NSInteger)section;

- (void)headerRereshing;
- (void)footerRereshing;

#pragma mark -- 编辑状态提交操作
- (void) commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) addChildViewControllerToContainer: (UIViewController *)childController addToView: (BOOL) addToView;
- (void) removeChildViewControllerFromContainer: (UIViewController *)childController;

- (CGFloat) heightForHeaderInSection:(NSInteger)section;
- (CGFloat) heightForFooterInSection:(NSInteger)section;

-(UIView *) viewForHeaderInSection:(NSInteger)section;
-(UIView *) viewForFooterInSection:(NSInteger)section;

- (NSString *) reuseIdentifierForCellAtIndexPath: (NSIndexPath *)indexPath;

- (UIView *) headerOrFooterView: (BOOL) isHeader;

- (NSString *) keyForIndexPath: (NSIndexPath *) indexPath;

-(void) willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)registerForKeyboardNotifications;
-(NSDictionary *) propertiesForCellAtIndexPath: (NSIndexPath *) indexPath contentView: (UIView *) contentView;

@end
