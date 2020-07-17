//
//  UIView+ext.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "UIView+ext.h"
@implementation UIView (ext)


static NSString * const kShakingKey = @"isShaking";
- (void)setShaking:(BOOL)shaking{
    objc_setAssociatedObject(self, &kShakingKey, @(shaking), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shaking
{
    return [objc_getAssociatedObject(self, &kShakingKey) boolValue];
}


-(void)shakeAnimate
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = self.transform.tx;
    animation.duration = 2;
    NSInteger shakeTimes = 150; // 震荡次数
    CGFloat max_swing = 4;// 最大振幅
    CGFloat damping = max_swing / (CGFloat)shakeTimes;
    NSMutableArray * values = [NSMutableArray array];
    for (NSInteger i = 0; i<shakeTimes; i++) {
        CGFloat swing = max_swing - damping * (CGFloat)i;
        CGFloat change = (i%2==0)?swing:(-swing);
        [values addObject:@(currentTx + change)];
    }
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"shakeAnimate"];
}


-(CAEmitterLayer *)explosionLayer
{
    CAEmitterLayer *explosionLayer;
    for (CALayer * subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAEmitterLayer class]]) {
            if ([subLayer.name isEqualToString:@"emitterLayer"]) {
                explosionLayer = (CAEmitterLayer *)subLayer;
            }
        }
    }
    
    if (!explosionLayer) {
        explosionLayer= [CAEmitterLayer layer];
        explosionLayer.name          = @"emitterLayer";
        explosionLayer.emitterShape  = kCAEmitterLayerCircle;
        explosionLayer.emitterMode   = kCAEmitterLayerOutline;
        explosionLayer.emitterSize   = self.frame.size;
        explosionLayer.renderMode    = kCAEmitterLayerOldestFirst;
        explosionLayer.masksToBounds = NO;
        explosionLayer.position      = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        explosionLayer.zPosition     = -1;
        [self.layer addSublayer:explosionLayer];
    }
    return explosionLayer;
}

-(void)boomWithColor:(UIColor *)color
{
    [self boomWithColor:color andCellLifeTime:1.0 andStopTime:0.1 andEmitterSize:self.frame.size andCellVelocity:40.0];
}


-(void)boomWithColor:(UIColor *)color andCellLifeTime:(float)lifeTime andStopTime:(NSTimeInterval)stopTime andEmitterSize:(CGSize)emitterSize andCellVelocity:(CGFloat)velocity;
{
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name           = @"explosion";
    explosionCell.alphaRange     = 0.10;
    explosionCell.alphaSpeed     = -1.0;
    explosionCell.lifetime       = lifeTime;
    explosionCell.lifetimeRange  = 0.3;
    explosionCell.birthRate      = 0;
    explosionCell.velocity       = velocity;
    explosionCell.velocityRange  = 10.00;
    explosionCell.scale          = 0.03;
    explosionCell.scaleRange     = 0.02;
    explosionCell.contents       = (id)[UIImage qmui_imageWithColor:color size:self.frame.size cornerRadius:self.frame.size.width/2].CGImage;
    
    self.explosionLayer.emitterSize = emitterSize;
    self.explosionLayer.emitterCells  = @[explosionCell];
    
    // 开始喷射
    self.explosionLayer.beginTime = CACurrentMediaTime();
    [self.explosionLayer setValue:@1000 forKeyPath:@"emitterCells.explosion.birthRate"];
    //停止喷射
    [self performSelector:@selector(stopExplosion) withObject:nil afterDelay:stopTime];
}


-(void)stopExplosion
{
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}



-(UIViewController *)getCurrentController
{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            NSLog(@"UIViewControllerClass:%@",NSStringFromClass([responder class]));
            UIViewController * vc = (UIViewController *)responder;
            if (vc.parentViewController && (![vc.parentViewController isKindOfClass:[UINavigationController class]])) {
                return vc.parentViewController;
            }
            return vc;
        }
    }
    return nil;
}
@end
