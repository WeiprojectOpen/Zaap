//
//  Plist.h
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plist : NSObject {
    NSBundle *_bundle;
}

@property (nonatomic,strong)NSDictionary *root;
@property (nonatomic,strong)NSBundle *bundle;

+ (NSBundle *)resourceBundle:(NSString *)bundleName;
-(id)initWithPlistFile:(NSString *) namedPlist;
-(id) initWithPlistFile:(NSString *) namedPlist bundle: (NSBundle *) bundle;
- (id) objectFromPath: (NSString*) path;

@end
