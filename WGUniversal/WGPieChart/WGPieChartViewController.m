//
//  WGPieChartViewController.m
//  WGUniversal
//
//  Created by 莹 申 on 14-12-3.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGPieChartViewController.h"
#import "WGPieChart.h"

@interface WGPieChartViewController () {
    WGPieChart *_wgPieChart;
}

@end

@implementation WGPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildPieChart];
}

- (void) buildPieChart {
    _wgPieChart = [[WGPieChart alloc] initWithFrame:self.view.bounds];
    _wgPieChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_wgPieChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _wgPieChart.pieRadius = MIN(_wgPieChart.frame.size.width/2, _wgPieChart.frame.size.height/2) - 10;
    _wgPieChart.pieCenter = CGPointMake(_wgPieChart.frame.size.width/2, _wgPieChart.frame.size.height/2);
    _wgPieChart.labelRadius = _wgPieChart.pieRadius * 2 /3;
    _wgPieChart.showPercentage = NO;
    
    [_wgPieChart reloadData];
    
    NSLog(@"_wgPieChart reloaded");
    
    //_wgPieChart.backgroundColor = [UIColor blackColor];
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
