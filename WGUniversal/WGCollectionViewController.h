//
//  WGCollectionViewControler.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGBaseViewController.h"
#import "RFQuiltLayout.h"


@protocol WGCollectionViewDelegate <NSObject>

//- (UIView *) createCollectionViewCellSubview;

//- (void) WGPageLoader:(WGPageLoader *)_mycell didSelecteDate:(NSDate*)_date;

@end




@interface WGCollectionViewController : WGBaseViewController<RFQuiltLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) id<WGCollectionViewDelegate> delegate;
@property (nonatomic, strong) RFQuiltLayout *blockLayout;





-(void)buildCollectionView;

@end
