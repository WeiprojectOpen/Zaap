//
//  HomeUICollectionViewFlowLayout.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-7.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "HomeUICollectionViewFlowLayout.h"
#import "WGPlist.h"
#import "WGPageLoader.h"

@interface HomeUICollectionViewFlowLayout ()

@property (nonatomic,strong)Plist * homePlist;
@property (nonatomic,strong)NSDictionary *HomeCollectionStyle;

@end



@implementation HomeUICollectionViewFlowLayout

- (instancetype)initWithPath: (NSString *) path andPlist: (Plist *) plist
{
    self = [super init];
    if (self)
    {
        _HomeCollectionStyle =[plist objectFromPath:[NSString stringWithFormat: @"%@/FlowLayout", path]];
        
        NSString *autoresize = [_HomeCollectionStyle objectForKey:@"auto-size"];
        
        BOOL isAutoResize = autoresize == nil || ![autoresize boolValue] ? NO : YES;
        CGFloat fixRatio = 1.0;
        if(isAutoResize) {
            WGPageLoader *_pageLoader = [WGPageLoader getCurrentInstance];
            fixRatio = [_pageLoader fixRatio];
        }
        
        
        float itemSizeWidth  = fixRatio * [[_HomeCollectionStyle objectForKey:@"itemSizeWidth"]floatValue];
        float itemSizeHeight =fixRatio * [[_HomeCollectionStyle objectForKey:@"itemSizeHeight"]floatValue];
        
        float sectionInsetTop    =fixRatio * [[_HomeCollectionStyle objectForKey:@"sectionInsetTop"]floatValue];
        float sectionInsetLeft   =fixRatio * [[_HomeCollectionStyle objectForKey:@"sectionInsetLeft"]floatValue];
        float sectionInsetBottom =fixRatio * [[_HomeCollectionStyle objectForKey:@"sectionInsetBottom"]floatValue];
        float sectionInsetrRght  =fixRatio * [[_HomeCollectionStyle objectForKey:@"sectionInsetrRght"]floatValue];
        
        self.itemSize                = CGSizeMake(itemSizeWidth, itemSizeHeight); //60 60
        self.sectionInset            = UIEdgeInsetsMake(sectionInsetTop, sectionInsetLeft, sectionInsetBottom, sectionInsetrRght);
        self.minimumLineSpacing      = fixRatio * [[_HomeCollectionStyle objectForKey:@"minimumLineSpacing"]floatValue];
        self.minimumInteritemSpacing = fixRatio * [[_HomeCollectionStyle objectForKey:@"minimumInteritemSpacing"]floatValue];
        
    }
    return self;
}

//http://blog.sina.com.cn/s/blog_8280f5ec0100tt2c.html
@end
