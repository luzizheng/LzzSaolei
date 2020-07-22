//
//  UIButton+ext.m
//  LzzSaolei
//
//  Created by sl_Luzz on 2020/7/20.
//  Copyright © 2020 sl. All rights reserved.
//

#import "UIButton+ext.h"
#import <objc/runtime.h>


@implementation UIButton (ext)
#pragma mark - 按钮防止快速连续点击
#define UIControl_acceptEventInterval @"UIControl_acceptEventInterval"
#define UIControl_acceptedEventTime @"UIControl_acceptedEventTime"
- (NSTimeInterval)sl_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setSl_acceptEventInterval:(NSTimeInterval)sl_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(sl_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)sl_acceptedEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptedEventTime) doubleValue];
}
- (void)setSl_acceptedEventTime:(NSTimeInterval)sl_acceptedEventTime{
    objc_setAssociatedObject(self, UIControl_acceptedEventTime, @(sl_acceptedEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.sl_acceptedEventTime < self.sl_acceptEventInterval){
        return;
    }
    if (self.sl_acceptEventInterval>0) {
        self.sl_acceptedEventTime =NSDate.date.timeIntervalSince1970;
    }
    [super sendAction:action to:target forEvent:event];
}

#pragma mark - /// 扩大button的点击范围(四个方向)

static char* const expandHitKey = "expandHitKey";
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.expandHitFloat>0){
        CGFloat expand = self.expandHitFloat;
        CGRect buttonFrame = self.bounds;
        CGRect hitFrame = CGRectMake(-expand, -expand, buttonFrame.size.width + 2 * expand, buttonFrame.size.height + 2*expand);
        return CGRectContainsPoint(hitFrame, point);
    }else{
        return [super pointInside:point withEvent:event];
    }
}

-(CGFloat)expandHitFloat
{
    return [objc_getAssociatedObject(self, expandHitKey) doubleValue];
}

- (void)setExpandHitFloat:(CGFloat)expandHitFloat
{
    objc_setAssociatedObject(self, expandHitKey, [NSNumber numberWithDouble:expandHitFloat], OBJC_ASSOCIATION_RETAIN);
}


@end
