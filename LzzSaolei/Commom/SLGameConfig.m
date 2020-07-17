//
//  SLGameConfig.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLGameConfig.h"

@interface SLGameConfig()


@property(nonatomic,assign,readwrite)NSTimeInterval gameTime;
@property(nonatomic,strong)NSTimer * timer;


@end

@implementation SLGameConfig
@synthesize openSound = _openSound;

SLSingletonM(SLGameConfig)


-(void)startGame
{
    
    self.gameTime = 0;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(perSecondTimeGoing:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}





-(void)perSecondTimeGoing:(id)sender
{
    self.gameTime += 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_timeSecond object:nil userInfo:nil];
}


-(void)endGame
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)resetGameTime
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.gameTime = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_timeSecond object:nil userInfo:nil];
}
@end
