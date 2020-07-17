//
//  CHEMMFontImage.h
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHEMMIconFont.h"
NS_ASSUME_NONNULL_BEGIN

@interface CHEMMFontImage : NSObject
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color;
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color padding:(CGFloat)paddingPercent;
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color inset:(UIEdgeInsets)inset;

//自定义背景色
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color withBackgroundColor:(UIColor*)backgroundColor;
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color padding:(CGFloat)paddingPercent withBackgroundColor:(UIColor*)backgroundColor;
+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color inset:(UIEdgeInsets)inset withBackgroundColor:(UIColor*)backgroundColor;
@end

NS_ASSUME_NONNULL_END
