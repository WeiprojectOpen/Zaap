//
//  WGViewController.m
//  WGUniversal
//
//  Created by AndyM on 14/11/19.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface WGViewController ()<UICollectionViewDelegate>{
    
    int Widths;
    int Heights;
    RFQuiltLayout* _layout;
}

@property (nonatomic) NSMutableArray* numbers;
@property (nonatomic) NSMutableArray* numberWidths;
@property (nonatomic) NSMutableArray* numberHeights;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

int num = 0;

@implementation WGViewController


-(void)buildCollectionView{
    
    [self datasInit];
    
    _layout = [[RFQuiltLayout alloc] init];
    _layout.direction = UICollectionViewScrollDirectionVertical;
    _layout.blockPixels = CGSizeMake(75,75);
    _layout.delegate = self;
    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout: _layout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.collectionView];
    
}

- (void)datasInit {
    num = 0;
    self.numbers = [@[] mutableCopy];
    self.numberWidths = @[].mutableCopy;
    self.numberHeights = @[].mutableCopy;
    for(num=0; num<13; num++) {
        
        switch (num) {
            case 0:
            {
                Widths =1;
                Heights=1;
                
                break;
            }
            case 1:
            {
                Widths =1;
                Heights=1;
                
                
                break;
            }case 2:
            {
                Widths =1;
                Heights=1;
                
                
                break;
            }case 3:
            {
                Widths =1;
                Heights=1;
                
                
                break;
            }case 4:
            {
                Widths =1;
                Heights=1;
                
                break;
            }case 5:
            {
                Widths =1;
                Heights=1;
                
                break;
            }case 6:
            {
                Widths =1;
                Heights=1;
                
                
                break;
            }case 7:
            {
                Widths =1;
                Heights=3;
                
                break;
            }case 8:
            {
                Widths =1;
                Heights=1;
                
                break;
            }case 9:
            {
                Widths =1;
                Heights=1;
                
                break;
            }case 10:
            {
                Widths =1;
                Heights=1;
                
                
                break;
            }case 11:
            {
                Widths =1;
                Heights=1;
                
                break;
            }case 12:
            {
                Widths =2;
                Heights=1;
                
                break;
            }
                
            default:
                break;
        }
        
        [self.numbers addObject:@(num)];
        [self.numberWidths addObject:@(Widths)];
        [self.numberHeights addObject:@(Heights)];
        
    }
    
    
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor redColor];
    
    return cell;
}


#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row >= self.numbers.count) {
        NSLog(@"Asking for index paths of non-existant cells!! %d from %d cells", indexPath.row, self.numbers.count);
    }
    
    CGFloat width = [[self.numberWidths objectAtIndex:indexPath.row] floatValue];
    CGFloat height = [[self.numberHeights objectAtIndex:indexPath.row] floatValue];
    
    return CGSizeMake(width, height);
    
}

//间距
- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
