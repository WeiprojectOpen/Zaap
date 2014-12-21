//
//  WGTableViewCell.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-26.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGTableViewCell.h"
#import "WGPageLoader-internal.h"

@implementation WGTableViewCell
@synthesize _title,_content,_image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        if([self respondsToSelector:@selector(setLayoutMargins:)]) {
//            UIEdgeInsets edge = UIEdgeInsetsZero;
//        
//            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(setLayoutMargins:)];
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//            invocation.selector = @selector(setLayoutMargins:);
//            [invocation setArgument:&edge atIndex:0];
//            
//            [invocation performSelector:@selector(setLayoutMargins:) withObject:self];
//            //[self performSelector:@selector(setLayoutMargins:) withObject:NSInvocation(UIEdgeInsetsZero)];
//        }
        //self.layoutMargins =UIEdgeInsetsZero;
        //self.contentView.backgroundColor = [UIColor clearColor];
        // Initialization codeperformSelector
//        _image =[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
//            
//        _title =[[UILabel alloc]initWithFrame:CGRectMake(54, 0, self.bounds.size.width, 20)];
//        _title.font=[UIFont systemFontOfSize:18];
//        
//        _content =[[UILabel alloc]initWithFrame:CGRectMake(54, 20,self.bounds.size.width-54, 24)];
//        _content.numberOfLines = 2;
//        _content.font=[UIFont systemFontOfSize:13];
//        
//        UIColor *color =[UIColor clearColor];
//        
//        _image.backgroundColor=[UIColor redColor];
//        _image.layer.masksToBounds=YES;
//        _image.layer.cornerRadius =8.0;
//        _image.layer.borderWidth = 1.0;
//        //        _image.layer.borderColor = [[UIColor grayColor] CGColor];
//        _image.layer.borderColor=[[UIColor colorWithRed:224/255.f green:224/255.f blue:224/255.f alpha:0.8]CGColor];
//        
//        _title.backgroundColor=[UIColor yellowColor];
//        _title.textAlignment=NSTextAlignmentLeft;
//        _title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//        
//        _content.backgroundColor=color;
//        
//        _content.textColor=[UIColor grayColor];
//        _content.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//        
//        [self.contentView addSubview:_title];
//        [self.contentView addSubview:_content];
//        [self.contentView addSubview:_image];
    }
    

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
