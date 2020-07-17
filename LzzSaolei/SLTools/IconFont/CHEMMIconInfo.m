//
//  CHEMMIconInfo.m
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import "CHEMMIconInfo.h"

@implementation CHEMMIconInfo
- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
        self.imageInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color inset:(UIEdgeInsets)inset {
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
        self.imageInsets = inset;
    }
    return self;
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    return [[CHEMMIconInfo alloc] initWithText:text size:size color:color];
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color inset:(UIEdgeInsets)inset {
    return [[CHEMMIconInfo alloc] initWithText:text size:size color:color inset:inset];
}
@end
