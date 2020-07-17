//
//  SLGridMap.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLControlToolView.h"

NS_ASSUME_NONNULL_BEGIN

@class SLGridView;

@interface SLGridMap : UIView

@property(nonatomic,strong,readonly)SLControlToolView * toolView;


-(void)generateGripMap;

-(NSArray <SLGridView *>*)getAroundGridsByGrid:(SLGridView *)grid;

/// 布雷 （为了保证第一个点击的不是雷，所以在点击第一个格子后才开始布雷)
-(void)releaseBoomIfNeedByFirstClick:(SLGridView *)firstClickGrid;

/// 扫周边的雷
-(void)sweepAroundByGrid:(SLGridView *)grid;


/// 每挖一个雷，检查一下游戏进程
-(void)checkGameProgress;




@end

NS_ASSUME_NONNULL_END
