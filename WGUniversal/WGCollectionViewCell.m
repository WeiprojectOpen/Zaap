//
//  WGCollectionViewCell.m
//  ZhaobaoApp
//
//  Created by 莹 申 on 14-8-13.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGCollectionViewCell.h"
#import "WGPageLoader.h"

@implementation WGCollectionViewCell



- (NSString *) pathFromReuseIdentifier: (NSString *) identifier {
    return [identifier stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code   
}
*/

@end
