//
//  CHEMMIconInfo.h
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHEMMIconInfo : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) UIEdgeInsets imageInsets;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *fontName;

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color inset:(UIEdgeInsets)inset;
+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color inset:(UIEdgeInsets)inset;
@end

NS_ASSUME_NONNULL_END
