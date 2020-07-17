//
//  SLAudioTool.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLAudioTool.h"

@interface SLAudioTool()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong,readwrite)AVPlayer *bgmPlayer;
@end

@implementation SLAudioTool

SLSingletonM(SLAudioTool)


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SLGameConfig sharedInstance] addObserver:self forKeyPath:@"openSound" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"openSound"]) {
        BOOL open = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (open) {
            [self.bgmPlayer play];
        }else{
            [self.bgmPlayer pause];
        }
    }
}


-(void)playAudioWithFileName:(NSString *)fileName
{
    [self playAudioWithFileName:fileName withForce:NO];
}
-(void)forcePlayAudioWithFileName:(NSString *)fileName
{
    [self playAudioWithFileName:fileName withForce:YES];
}
-(void)playAudioWithFileName:(NSString *)fileName withForce:(BOOL)force
{
    if ([SLGameConfig sharedInstance].openSound == NO) {
        return;
    }
    
    if (force == NO) {
        if (self.player.rate != 0.0) {
            return;
        }
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"];
    
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    // 播放
    [self.player play];
}

-(void)playBGM:(NSString *)fileName repeat:(BOOL)repeat
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    [item qmui_bindBOOL:repeat forKey:@"repeat"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bgmPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    
    [self.bgmPlayer replaceCurrentItemWithPlayerItem:item];
    [item seekToTime:kCMTimeZero];
    
    // 播放
    if ([SLGameConfig sharedInstance].openSound) {
        [self.bgmPlayer play];
    }else{
        [self.bgmPlayer pause];
    }
    
}

-(void)bgmPlayDidEnd:(NSNotification *)noti
{
    if (noti.object) {
        if ([noti.object isKindOfClass:[AVPlayerItem class]]) {
            AVPlayerItem * item = noti.object;
            
            BOOL repeat = [item qmui_getBoundBOOLForKey:@"repeat"];
            if (repeat) {
                [item seekToTime:kCMTimeZero];
                [self.bgmPlayer play];
            }
            
        }
    }
}


- (AVPlayer *)player
{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}


- (AVPlayer *)bgmPlayer
{
    if (!_bgmPlayer) {
        _bgmPlayer = [[AVPlayer alloc] init];
    }
    return _bgmPlayer;
}




@end
