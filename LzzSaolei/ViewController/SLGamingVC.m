//
//  SLGamingVC.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/14.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLGamingVC.h"
#import "SLGridMap.h"
#import "SLHeadView.h"
@interface SLGamingVC ()
@property(nonatomic,strong)SLHeadView * headView;
@property(nonatomic,strong)SLGridMap * gridMap;
@end

@implementation SLGamingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SLColorBackground;
    
    [SLGameConfig sharedInstance].hardLevel = SLHardLevelMediem;
    
    self.headView = [[SLHeadView alloc] init];
    [self.view addSubview:self.headView];
    
    self.gridMap = [[SLGridMap alloc] init];
    [self.view addSubview:self.gridMap];
    
    
    [self.gridMap generateGripMap];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.headView.frame = CGRectMake(0, 0, self.view.qmui_width, NavigationContentTop);
    
    CGFloat down = self.view.qmui_height - self.headView.qmui_bottom;
    
    CGSize gridMapSize = [self.gridMap sizeThatFits:CGSizeMax];
    self.gridMap.frame = CGRectMakeWithSize(gridMapSize);
    self.gridMap.center = CGPointMake(self.view.qmui_width/2, self.headView.qmui_bottom + down/2);
}






@end
