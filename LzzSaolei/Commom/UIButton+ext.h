//
//  UIButton+ext.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/20.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ext)
/**
 *  按钮防止快速连续点击加时间间隔.
 */
@property (nonatomic, assign) NSTimeInterval sl_acceptEventInterval;

/// 扩大button的点击范围(四个方向)
@property(nonatomic,assign)CGFloat expandHitFloat;



@end

NS_ASSUME_NONNULL_END
