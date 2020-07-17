//
//  AlertTool.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/16.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit/QMUIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SLAlertTool : NSObject
+(void)showAlertWithMainColor:(UIColor *)mainColor andTitle:(NSString *)title andMsg:(NSString *)msg andBtnTitle:(NSString *)btnTitle andBtnHandler:(nullable void (^)(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action))handler;
@end

NS_ASSUME_NONNULL_END
