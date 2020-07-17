//
//  AlertTool.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/16.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLAlertTool.h"

@implementation SLAlertTool


+(void)showAlertWithMainColor:(UIColor *)mainColor andTitle:(NSString *)title andMsg:(NSString *)msg andBtnTitle:(NSString *)btnTitle andBtnHandler:(nullable void (^)(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action))handler
{
    // 底部按钮
    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:btnTitle style:QMUIAlertActionStyleDefault handler:handler];

    
    // 弹窗
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:title message:msg preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertContentCornerRadius = 4;
    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
    titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    titleAttributs[NSFontAttributeName] = SLFont(18);
    alertController.alertTitleAttributes = titleAttributs;
    NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertMessageAttributes];
    messageAttributs[NSForegroundColorAttributeName] = UIColorMakeWithRGBA(255, 255, 255, 0.75);
    messageAttributs[NSFontAttributeName] = SLFont(15);
    alertController.alertMessageAttributes = messageAttributs;
    alertController.alertHeaderBackgroundColor = mainColor;
    alertController.alertSeparatorColor = alertController.alertButtonBackgroundColor;
    alertController.alertTitleMessageSpacing = 7;
    
    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = alertController.alertHeaderBackgroundColor;
    buttonAttributes[NSFontAttributeName] = SLFont(17);
    alertController.alertButtonAttributes = buttonAttributes;
    
    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertCancelButtonAttributes];
    cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
    cancelButtonAttributes[NSFontAttributeName] = SLFont(17);
    alertController.alertCancelButtonAttributes = cancelButtonAttributes;
    
    [alertController addAction:action];
    [alertController showWithAnimated:YES];
    
}

@end
