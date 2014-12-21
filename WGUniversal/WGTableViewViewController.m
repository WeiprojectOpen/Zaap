//
//  WGTableViewViewController.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-27.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGTableViewViewController.h"

#import "WGPlist.h"
#import "WGPageLoader.h"
#import "WGPageLoader-internal.h"
#import "UIColor+HexString.h"
#import "UIView+WGViewInfo.h"
#import "WGTableViewCell.h"
#import "WGUIScrollViewViewController.h"
#import "Masonry.h"

@interface WGTableViewViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation WGTableViewViewController


-(void)bulidTableView{
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.allowsSelection = YES;
    //_tableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bulidTableView];
}

#pragma mark-numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForFooterInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [self reuseIdentifierForCellAtIndexPath:indexPath];
    [_tableView registerClass:[WGTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    WGTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
 
    [self bindSubviewToCellContentView:cell.contentView cellForItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self willDisplayCell:cell forRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didDeselectItemAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectItemAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[WGPageLoader getCurrentInstance] isIOS8OrHigher]){
        return -1;
//        CGFloat height = [self heightForCellAtIndexPath:indexPath];
//        return height;
    }
    else {
        CGFloat height = [self heightForCellAtIndexPath:indexPath];
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterInSection:section];
}

@end

