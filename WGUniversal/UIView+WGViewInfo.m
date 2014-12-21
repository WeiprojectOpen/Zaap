#import "UIView+WGViewInfo.h"
#import <objc/runtime.h>

@interface UIView()
@end


@implementation UIView (WGViewInfo)

#pragma mark - 运行时相关
static char WGViewInfoKey;

- (void)setWgInfo:(WGViewInfo *)wgInfo {
    [self willChangeValueForKey:@"WGViewInfoKey"];
    objc_setAssociatedObject(self, &WGViewInfoKey,
                             wgInfo,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"WGViewInfoKey"];
}

- (WGViewInfo *)wgInfo {
    return objc_getAssociatedObject(self, &WGViewInfoKey);
}

@end
