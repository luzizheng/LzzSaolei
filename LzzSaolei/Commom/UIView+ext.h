//
//  UIView+ext.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ext)


@property(nonatomic,assign)BOOL shaking;

// 摇晃
-(void)shakeAnimate;

/// 爆炸
-(void)boomWithColor:(UIColor *)color;

/// 爆炸
-(void)boomWithColor:(UIColor *)color andCellLifeTime:(float)lifeTime andStopTime:(NSTimeInterval)stopTime andEmitterSize:(CGSize)emitterSize andCellVelocity:(CGFloat)velocity;


-(UIViewController *)getCurrentController;
@end

NS_ASSUME_NONNULL_END
