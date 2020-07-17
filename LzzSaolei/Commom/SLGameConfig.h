//
//  SLGameConfig.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLGameConfig : NSObject
SLSingletonH(SLGameConfig)

@property(nonatomic,assign,readonly)NSTimeInterval gameTime;
@property(nonatomic,assign)SLHardLevel hardLevel; // 0 容易 1中等 2难

@property(nonatomic,assign)BOOL openSound;

@property(nonatomic,assign)BOOL userInternactionalForGame;

-(void)startGame;


-(void)endGame;

-(void)resetGameTime;




@end

NS_ASSUME_NONNULL_END
