//
//  EColumnChartViewController.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGBaseViewController.h"
#import "EColumnChart.h"
@interface EColumnChartViewController : WGBaseViewController <EColumnChartDelegate, EColumnChartDataSource>

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


@end
