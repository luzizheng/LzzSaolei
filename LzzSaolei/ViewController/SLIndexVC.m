//
//  SLIndexVC.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/17.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLIndexVC.h"
#import "SLGamingVC.h"
#import "AppDelegate.h"
@interface SLIndexVC ()
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIView * boomPoint;
@property(nonatomic,strong)AVPlayer * player;
@end

@implementation SLIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = SLColorNavigationBar;
    
    self.label =[[UILabel alloc] qmui_initWithFont:SLFont(43) textColor:[UIColor whiteColor]];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"Mine Sweeper";
    [self.view addSubview:self.label];
    
    self.boomPoint = [UIView new];
    [self.view addSubview:self.boomPoint];
    self.player = [[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"audio_cell" withExtension:@"mp3"]];
    [self.player play];
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.label sizeToFit];
    self.label.center = CGPointMake(self.view.qmui_width/2, self.view.qmui_height/2);
    
    self.boomPoint.frame = CGRectMakeWithSize(CGSizeMake(30, 30));
    self.boomPoint.center = self.label.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jumpToNextAnimate];
    });
}

-(void)jumpToNextAnimate
{
    
    SLGamingVC * vc = [[SLGamingVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.boomPoint boomWithColor:self.label.textColor andCellLifeTime:3.0 andStopTime:1.0 andEmitterSize:CGSizeMake(1, 1) andCellVelocity:200.0];
    [UIView animateWithDuration:1.0 animations:^{
        self.label.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
        self.label.layer.opacity = 0.0;
    } completion:^(BOOL finished) {
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

@end
