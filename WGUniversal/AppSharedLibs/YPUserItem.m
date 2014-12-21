//
//  KNSelectorItem.m
//  KNFBFriendSelectorDemo
//
//  Created by Kent Nguyen on 4/6/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "YPUserItem.h"

@implementation YPUserItem

@synthesize displayValue,sortValue, selectValue, imageUrl, selected,tag,detailValue,facebookId;

-(id)initWithDisplayValue:(NSString*)displayVal {
  return [self initWithDisplayValue:displayVal selectValue:displayVal imageUrl:nil];
}

-(id)initWithDisplayValue:(NSString*)displayVal
              selectValue:(NSString*)selectVal
                 imageUrl:(NSString*)image {
  if ((self=[super init])) {
    self.displayValue = displayVal;
    self.selectValue = selectVal;
    self.imageUrl = image;
  }
  return self;
}
-(void)change:(NSString *)str{
    [self.delegate change:self.displayValue];
}
#pragma mark - Sort comparison

-(NSComparisonResult)compareByDisplayValue:(YPUserItem*)other {
  return [self.displayValue compare:other.displayValue];
}

-(NSComparisonResult)compareBySelectedValue:(YPUserItem*)other {
  return [self.selectValue compare:other.selectValue];
}

-(NSComparisonResult)compareBySortValue:(YPUserItem*)other {
    return [self.sortValue compare:other.sortValue];
}
@end
