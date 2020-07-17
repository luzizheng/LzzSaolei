//
//  SLGridView.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/14.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGridMap.h"


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,SLGridStatus) {
    SLGridStatusDefault = 0,
    SLGridStatusOpened,
    SLGridStatusFlag,
    
};

@interface SLGridPosition : NSObject

@property(nonatomic,assign)NSInteger x;
@property(nonatomic,assign)NSInteger y;

@property(nonatomic,copy,readonly)NSString * stringForKey;

+(instancetype)positionWithX:(NSInteger)x andY:(NSInteger)y;

@end

@interface SLGridView : UIView

@property(nonatomic,weak,readonly)SLGridMap * targetMap;

@property(nonatomic,strong)SLGridPosition * gridPosition;

/// 周边有多少炸弹 (外部设置)
@property(nonatomic,assign)NSInteger boomNumberAround;

/// 边长
@property(nonatomic,assign)CGFloat width;

/// 是否有雷
@property(nonatomic,assign)BOOL hasBoom;

@property(nonatomic,assign)SLGridStatus status;

/// 动态值，用作检测是否可以扫周边
@property(nonatomic,assign,readonly)BOOL canSweepAround;

-(instancetype)initWithGridPosition:(SLGridPosition *)gridPosition;



/// 铲
-(void)openGrid;

/// 游戏结束时调用
-(void)gameOverShowBoomOut;

@end

NS_ASSUME_NONNULL_END
