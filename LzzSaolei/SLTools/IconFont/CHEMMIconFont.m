//
//  CHEMMIconFont.m
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import "CHEMMIconFont.h"
#import <CoreText/CoreText.h>
@implementation CHEMMIconFont
static NSString *_fontName;
+ (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self fontName] size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:[self fontName] withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        NSURL *configFontUrl = [[NSBundle mainBundle] URLForResource:@"iconfont_config" withExtension:@"ttf"];
        [self registerFontWithURL: configFontUrl];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

+ (UIFont *)fontWithSize: (CGFloat)size withFontName:(NSString*)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        NSURL *configFontUrl = [[NSBundle mainBundle] URLForResource:@"iconfont_config" withExtension:@"ttf"];
        [self registerFontWithURL: configFontUrl];
        font = [UIFont fontWithName:fontName size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

+(UIFont *)fontWithOldIconFontSize:(CGFloat)size
{
    NSString * fontName =@"fonteditor";
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        font = [UIFont fontWithName:fontName size:size];
    }
    
    return font;
}

+(UIFont *)fontWithCarChatting:(CGFloat)size
{
    NSString * fontName = @"carchatting";
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        font = [UIFont fontWithName:fontName size:size];

    }
    return font;
}

+ (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
}

+ (NSString *)fontName {
    return _fontName ? : @"iconfont";
}

@end
