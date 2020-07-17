//
//  CHEMMIconFont.h
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import "UIImage+CHEMMIconFont.h"
#import "CHEMMIconInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHEMMIconFont : NSObject
+ (UIFont *)fontWithSize: (CGFloat)size;
+ (UIFont *)fontWithSize: (CGFloat)size withFontName:(NSString*)fontName;

/// 旧教授字体册
+(UIFont *)fontWithOldIconFontSize:(CGFloat)size;
+(UIFont *)fontWithCarChatting:(CGFloat)size;
+ (void)setFontName:(NSString *)fontName;
@end

NS_ASSUME_NONNULL_END
