//
//  WGPageLoader-internal.h
//  WGUniversal
//
//  Created by AndyM on 14-10-10.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGCollectionViewController.h"
#import "WGTableViewViewController.h"
#import "WGUIScrollViewViewController.h"
#import "WGMenuViewController.h"

#import "WGPlist.h"
#import "WGPageLoader.h"

@interface WGPageLoader() <WGCollectionViewDelegate> {
    NSMutableDictionary *_pages;
}

@property (nonatomic, strong) Plist* appPlist;
//@property (nonatomic, strong) Plist* currentPagePlist;
//@property (nonatomic, strong) NSString* currentPagePlistNamed;

//@property (nonatomic, strong) WGBaseViewController* currentPageVC;
//@property (nonatomic, assign) NSInteger currentPageId;


- (UITabBarController *) createTabBarControllerWithArray:(NSArray *) tabArray;

- (UINavigationController*) createUINativationControllerWithVC: (UIViewController *)vc andTabDict: (NSDictionary *) tabDict;

- (void)loadViewTreeForPlist:(Plist *)plist andViewPath:(NSString *)path forParent: (UIView *) parentView;

// ==============================================================================

// ======================================================================================


-(UIViewController *)createMenuUIViewController:(NSDictionary *) dict;



// ======================================================================================
- (void) applyPropertiesToView: (UIView *) view properties: (NSDictionary *) subviewOption inPath: (NSString *)path forParentView: (UIView *) parentView;

- (id) defaultValueForParam:(NSString *) paramName  key: (NSString *)key ofView: (UIView *) view;


- (NSUInteger)numberOfSlicesInChart:(UIView *) view;
- (CGFloat)view:(UIView *)view valueForSliceAtIndex:(NSUInteger)index;
- (UIColor *)view:(UIView *)view colorForSliceAtIndex:(NSUInteger)index;


- (NSInteger)numberOfSlicesPresentedEveryTime:(UIView *) view;

- (CGFloat)highestValueOfChart:(UIView *)view;

- (NSString *) unitOfChart:(UIView *) view;

- (CGFloat)highestValueOfChart:(UIView *)view;

- (NSString *)view:(UIView *)view titleForSliceAtIndex:(NSUInteger)index;

//
@end