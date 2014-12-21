//
//  WGCollectionView.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGCollectionViewController.h"
#import "WGPlist.h"
#import "WGPageLoader.h"
#import "UIColor+HexString.h"
#import "UIView+WGViewInfo.h"
#import "HomeUICollectionViewFlowLayout.h"
#import "WGTableViewViewController.h"
#import "WGCollectionViewCell.h"


@interface WGCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
}



@end


@implementation WGCollectionViewController

/*- (id)initWithPage: (NSInteger) pageid plistNamed: (NSString *) plistNamed andPath: (NSString *) path
{
    self = [super initWithPage:pageid plistNamed:plistNamed andPath:path];
    if (self) {
        self.info.cellpath = [NSString stringWithFormat:@"%@/collectionview",path];
    }
    return self;
}*/

-(void)buildCollectionView
{

    
    HomeUICollectionViewFlowLayout *flowLayout = [[HomeUICollectionViewFlowLayout alloc] initWithPath: [self.view.wgInfo.properties objectForKey:@"flowLayout"] andPlist:self.plist];
    
    
    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    NSLog(@"[self pathToReuseIdentifier:self.view.wgInfo.path] = %@", [self pathToReuseIdentifier:self.view.wgInfo.path]);
    [self.collectionView registerClass:[WGCollectionViewCell class]
            forCellWithReuseIdentifier: @"collection"];
    
    // 设置代理对象
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    //self.collectionView.backgroundColor= self.view.backgroundColor;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.collectionView];
    
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSLog(@"xxxx-----------");
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
   // [self buildCollectionView];
}
//每个item的大小
- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize blockSize =[self blockSizeForItemIndexPath:indexPath];
    
    return blockSize;
}
//每个item的间距
- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIEdgeInsets insets =[self insetsForItemIndexPath:indexPath];

    return insets;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = [self numberOfRowsInSection:section];
    return rows;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = [self numberOfSections];
    return sections;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self didDeselectItemAtIndexPath:indexPath];
}

#pragma mark- cellForItemAtIndexPath
//http://my.oschina.net/CarlHuang/blog/139191 参考

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [self reuseIdentifierForCellAtIndexPath:indexPath];
    [self.collectionView registerClass:[WGCollectionViewCell class]
            forCellWithReuseIdentifier: reuseIdentifier];
    WGCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
    
    [self bindSubviewToCellContentView:cell.contentView cellForItemAtIndexPath:indexPath];
    
    return cell;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    [self didSelectItemAtIndexPath:indexPath];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    [self didEndDisplayingCell:cell forItemAtIndexPath:indexPath];

}


/*

 
 
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 
 //调节同一行的cell之间的距离的。
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 
// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
// 
// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
//
 
 
 //定义每个UICollectionView 的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return CGSizeMake(75, 95);
 }
 
 //定义每个UICollectionView 的 margin
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
 return UIEdgeInsetsMake(0, 0, 0, 0);
 }

 
 
 */
 
 



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
