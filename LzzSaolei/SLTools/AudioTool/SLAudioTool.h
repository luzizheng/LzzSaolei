//
//  SLAudioTool.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAudioTool : NSObject
SLSingletonH(SLAudioTool)

@property(nonatomic,strong,readonly)AVPlayer *bgmPlayer;

-(void)playAudioWithFileName:(NSString *)fileName;
-(void)forcePlayAudioWithFileName:(NSString *)fileName;


-(void)playBGM:(NSString *)fileName repeat:(BOOL)repeat;

@end

NS_ASSUME_NONNULL_END
