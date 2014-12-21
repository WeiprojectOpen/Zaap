//
//  Plist.m
//  ZhaobaoApp
//
//  Created by AndyM on 14-8-8.
//  Copyright (c) 2014年 WGHX. All rights reserved.
//

#import "WGPlist.h"

@implementation Plist

+ (NSBundle *)resourceBundle:(NSString *)bundleName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

-(id) initWithPlistFile:(NSString *) namedPlist bundle: (NSBundle *) bundle{
    
    self = [self init];
    
    //    NSBundle *bundle =[NSBundle mainBundle];
    if(bundle == nil) {
        _bundle = [[self class] resourceBundle: @"app"];
    }
    else {
        _bundle = bundle;
    }
    
    //    NSBundle *bundle =[NSBundle bundleWithPath:<#(NSString *)#>];
    NSString *plistPath= [_bundle pathForResource:namedPlist ofType:@"plist"];
    _root = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    return self;
}

-(id) initWithPlistFile:(NSString *) namedPlist{
   return [self initWithPlistFile:namedPlist bundle:nil];
}

- (id) objectFromPath: (NSString*) path{
    //NSString *myString = @"/sharesdk/1/appSecret";
    NSArray *keys = [path componentsSeparatedByString:@"/"];
    id currentNode = _root;
    for (int i=0; i<[keys count]; i++) {
        NSString *node = [keys objectAtIndex:i];
        int maybeArrayIndex = (int)[node integerValue]; //可能字符串也变成了0, 检测是否为数字或字符串需改进
        NSString *revertStr = [NSString stringWithFormat:@"%i", maybeArrayIndex];
        if([revertStr isEqualToString:node]) {
            currentNode = [currentNode objectAtIndex:maybeArrayIndex];
        }
        else {
            currentNode = [currentNode objectForKey:node];
            if([currentNode isKindOfClass:[NSString class]] && [currentNode rangeOfString:@".plist"].length > 0) {
                NSString *plistPath = [_bundle pathForResource:currentNode ofType:nil];
                currentNode = [[NSArray alloc] initWithContentsOfFile:plistPath];
            }
        }
    }
    return currentNode;
}

@end
