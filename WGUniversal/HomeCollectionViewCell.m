//
//  HomeCollectionViewCell.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-7.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "WGPlist.h"

@interface HomeCollectionViewCell ()

@property (nonatomic,strong)Plist * homePlist;
@property (nonatomic,strong)NSDictionary *HomeStyleRectImageView;
@property (nonatomic,strong)NSDictionary *HomeStyleRectLabelText;
@property (nonatomic,strong)NSDictionary *HomeStyleImageColor;
@property (nonatomic,strong)NSDictionary *HomeStyleLabelColor;

@end


@implementation HomeCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.backgroundColor=[UIColor whiteColor];

        _homePlist =[[Plist alloc]initWithPlistFile:@"pages/HomeVC"];
        _HomeStyleRectImageView =[_homePlist objectFromPath:@"HomeCollectionStyle/RectView/rectImageView"];
        _HomeStyleRectLabelText =[_homePlist objectFromPath:@"HomeCollectionStyle/RectView/rectLabelText"];
        _HomeStyleImageColor =[_homePlist objectFromPath:@"HomeCollectionStyle/Color/imageColor"];
        _HomeStyleLabelColor =[_homePlist objectFromPath:@"HomeCollectionStyle/Color/labelColor"];
        
        CGRect rectImageView =self.bounds;
        rectImageView.origin.x    += [[_HomeStyleRectImageView objectForKey:@"rectImageViewX"]floatValue];
        rectImageView.origin.y    += [[_HomeStyleRectImageView objectForKey:@"rectImageViewY"]floatValue];
        rectImageView.size.height -= [[_HomeStyleRectImageView objectForKey:@"rectImageViewW"]floatValue];
        rectImageView.size.width  -= [[_HomeStyleRectImageView objectForKey:@"rectImageViewH"]floatValue];
        
        _showHomeImageView =[[UIImageView alloc]initWithFrame:rectImageView];
        
        float imageWithRed =[[_HomeStyleImageColor objectForKey:@"imageWithRed"]floatValue];
        float imageWithGreen =[[_HomeStyleImageColor objectForKey:@"imageWithGreen"]floatValue];
        float imageWithBlue =[[_HomeStyleImageColor objectForKey:@"imageWithBlue"]floatValue];
        float imageAlpha =[[_HomeStyleImageColor objectForKey:@"imageAlpha"]floatValue];
    
        _showHomeImageView.backgroundColor=[UIColor colorWithRed:imageWithRed green:imageWithGreen blue:imageWithBlue alpha:imageAlpha];

//        _showHomeImageView.contentMode =UIViewContentModeCenter;
//        _showHomeImageView.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        CGRect rectLabelText =self.bounds;
        rectLabelText.origin.x    += [[_HomeStyleRectLabelText objectForKey:@"rectLabelTextX"]floatValue];
        rectLabelText.origin.y    += [[_HomeStyleRectLabelText objectForKey:@"rectLabelTextY"]floatValue];
        rectLabelText.size.height -= [[_HomeStyleRectLabelText objectForKey:@"rectLabelTextW"]floatValue];
        rectLabelText.size.width  -= [[_HomeStyleRectLabelText objectForKey:@"rectLabelTextH"]floatValue];
        
        _showHomeLabeText = [[UILabel alloc]initWithFrame:rectLabelText];
        
        float labelWithRed =[[_HomeStyleLabelColor objectForKey:@"labelWithRed"]floatValue];
        float labelWithGreen =[[_HomeStyleLabelColor objectForKey:@"labelWithGreen"]floatValue];
        float labelWithBlue =[[_HomeStyleLabelColor objectForKey:@"labelWithBlue"]floatValue];
        float labelAlpha =[[_HomeStyleLabelColor objectForKey:@"labelAlpha"]floatValue];
        
        _showHomeLabeText.backgroundColor=[UIColor colorWithRed:labelWithRed green:labelWithGreen blue:labelWithBlue alpha:labelAlpha];
        
        
        
        _showHomeLabeText.textAlignment =[[_HomeStyleRectLabelText objectForKey:@"textAlignment"]intValue];
        _showHomeLabeText.font=[UIFont systemFontOfSize:[[_HomeStyleRectLabelText objectForKey:@"font"]floatValue]];
        
        [_showHomeImageView addSubview:_showHomeLabeText];
        [self addSubview:_showHomeImageView];
        
    }
    
    return self;
}


@end
