//
//  UIImage+CHEMMIconFont.m
//  ChemmProfessor
//
//  Created by Chemm_Luzz on 2019/7/25.
//  Copyright © 2019 Chemm. All rights reserved.
//

#import "UIImage+CHEMMIconFont.h"
#import "CHEMMIconFont.h"
#import <CoreText/CoreText.h>

@implementation UIImage (CHEMMIconFont)
+ (UIImage *)iconWithInfo:(CHEMMIconInfo *)info
{
    CGFloat w1 = info.size - info.imageInsets.left - info.imageInsets.right;
    CGFloat w2 = info.size - info.imageInsets.top - info.imageInsets.bottom;
    CGFloat size = MIN(w1, w2);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    CGFloat imageSize = info.size * scale;
    UIFont *font = info.fontName ?
    [CHEMMIconFont fontWithSize:realSize withFontName:info.fontName] :
    [CHEMMIconFont fontWithSize:realSize];
    
    UIGraphicsBeginImageContext(CGSizeMake(imageSize, imageSize));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (info.backgroundColor) {
        [info.backgroundColor set];
        UIRectFill(CGRectMake(0.0, 0.0, imageSize, imageSize)); //fill the background
    }
    CGPoint point = CGPointMake(info.imageInsets.left*scale, info.imageInsets.top*scale);
    
    if ([info.text respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [info.text drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: info.color}];
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, info.color.CGColor);
        [info.text drawAtPoint:point withFont:font];
#pragma clang pop
    }
    
    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

@end
