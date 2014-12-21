//
//  WGUIPickerViewController.m
//  WGUniversal
//
//  Created by AndyM on 14/11/12.
//  Copyright (c) 2014年 AndyM. All rights reserved.
//

#import "WGUIPickerViewController.h"

@interface WGUIPickerViewController (){

 UIPickerView *pickerView;
    
}

@end

@implementation WGUIPickerViewController

//字符串过滤掉非法字符替换为_
- (NSString *) pathToReuseIdentifier: (NSString *) path {
    return [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}


-(void)bulidPickerView{
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 250)];
    //    指定Delegate
    pickerView.delegate=self;
    //    显示选中框
    pickerView.showsSelectionIndicator=YES;
    [self.view addSubview:pickerView];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self bulidPickerView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    return [self numberOfSections];
    
    
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    

    
//    return [self numberOfRowsInSection:component];
    
    

    
//    if (component == 0) { //选择了第一列
//        return [pickerTime count];
//    } else if(component == 1){//选择了第二列
//        return [pickerData count];
//    }else if(component ==2){
//        return [pickerTime1 count];
//        
//    }else{
//        
//        
//    }
//    
//    return nil;
    
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    

    if (component == 0) { //选择了第一列
        return [pickerTime objectAtIndex:row];
    } else if(component == 1){//选择了第二列
        return [pickerData objectAtIndex:row];
        
    }else if(component ==2){
        return [pickerTime1 objectAtIndex:row];
    }else{
        
    }
    
    
    
    
    return nil;
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
