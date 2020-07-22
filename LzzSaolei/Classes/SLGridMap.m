//
//  SLGridMap.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLGridMap.h"
#import "SLGridView.h"

@interface SLGridMap()
@property(nonatomic,strong,readwrite)SLControlToolView * toolView;
@property(nonatomic,strong)NSDictionary * levelInfo;
@property(nonatomic,assign)NSInteger rowNumber;
@property(nonatomic,assign)NSInteger lineNumber;
@property (nonatomic, assign)CGPoint itemForBoomPoint;
@property (nonatomic, strong)NSMutableDictionary * map;
@property(nonatomic,assign)BOOL hasReleaseBoom;

@property(nonatomic,assign)NSInteger openIndex;
@property(nonatomic,strong)NSTimer * openTimer;
@end

@implementation SLGridMap
#define kMargin 15.0
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridHasBoom:) name:kNotificationName_touchBoom object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateGripMap) name:kNotificationName_regenerateMap object:nil];
        [[SLGameConfig sharedInstance] addObserver:self forKeyPath:@"userInternactionalForGame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationName_touchBoom object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationName_regenerateMap object:nil];
    [[SLGameConfig sharedInstance] removeObserver:self forKeyPath:@"userInternactionalForGame" context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userInternactionalForGame"] && [object isEqual:[SLGameConfig sharedInstance]]) {
        BOOL value = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.userInteractionEnabled = value;
    }
}


// 炸了
-(void)gridHasBoom:(id)sender
{
    [[SLAudioTool sharedInstance] forcePlayAudioWithFileName:@"audio_boom"];
    
    NSMutableArray * temp = [NSMutableArray array];
    for (SLGridView * grid in self.map.allValues) {
        if (grid.hasBoom) {
            [temp addObject:grid];
        }
    }
    
    [self showAllBoomingGrid:temp];
    
}


-(void)showAllBoomingGrid:(NSArray <SLGridView *>*)girdsHasBoom
{
    __weak typeof(self)weakSelf = self;
    self.openIndex = 0;
    if (self.openTimer) {
        [self.openTimer invalidate];
        self.openTimer = nil;
    }
    self.openTimer = [NSTimer timerWithTimeInterval:0.1 target:weakSelf selector:@selector(openGridByIndex:) userInfo:@{@"array":girdsHasBoom} repeats:YES];
    [self.openTimer fireDate];
    [[NSRunLoop mainRunLoop] addTimer:self.openTimer forMode:NSRunLoopCommonModes];
}

-(void)openGridByIndex:(NSTimer *)t
{
    NSArray *grids = [t.userInfo objectForKey:@"array"];
       
       if (self.openIndex >= grids.count) {
           [t invalidate];
           self.openIndex = 0;
           [[SLGameConfig sharedInstance] endGame];
           [self showGameOverAlert];
       }else{
           SLGridView * thisGrid = [grids objectAtIndex:self.openIndex];
           [thisGrid gameOverShowBoomOut];
           self.openIndex +=1;
       }
}

-(void)showGameOverAlert
{
    [SLAlertTool showAlertWithMainColor:SLColorRed andTitle:@"Game Over" andMsg:@"You've got a mine..." andBtnTitle:@"Again" andBtnHandler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [self generateGripMap];
    }];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    for (SLGridView * grid in self.map.allValues) {
        grid.frame = CGRectMake(grid.width * grid.gridPosition.x,grid.width * grid.gridPosition.y, grid.width, grid.width);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat w = (SCREEN_WIDTH - 2*kMargin)/(CGFloat)self.rowNumber;
    return CGSizeMake(SCREEN_WIDTH - 2*kMargin, (CGFloat)self.lineNumber * w);
}

-(void)generateGripMap
{
    [SLGameConfig sharedInstance].userInternactionalForGame = NO;
    [[SLAudioTool sharedInstance] playAudioWithFileName:@"audio_robot"];
    switch ([SLGameConfig sharedInstance].hardLevel) {
        case SLHardLevelEasy:
            [[SLAudioTool sharedInstance] playBGM:@"bgm_01" repeat:YES];
            break;
        case SLHardLevelMediem:
            [[SLAudioTool sharedInstance] playBGM:@"bgm_02" repeat:YES];
            break;
        case SLHardLevelHard:
            [[SLAudioTool sharedInstance] playBGM:@"bgm_03" repeat:YES];
            break;
        default:
            break;
    }
    [[SLGameConfig sharedInstance] resetGameTime];
    
    if (self.map.allKeys.count>0) {
        [self.map.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.map removeAllObjects];
    }
    
    self.hasReleaseBoom = NO;
    
    CGFloat rowNumber = [[self.levelInfo objectForKey:[NSString stringWithFormat:@"%ld",(long)[SLGameConfig sharedInstance].hardLevel]] doubleValue];
    self.rowNumber = (NSInteger)rowNumber;
    CGFloat w = (SCREEN_WIDTH - 2*kMargin)/rowNumber;
    
    CGFloat heightArea = SCREEN_HEIGHT - NavigationContentTop - 2*kMargin;
    
    NSInteger heightNum = (NSInteger)(heightArea / w);
    self.lineNumber = heightNum;
    
    for (NSInteger i = 0 ; i<(NSInteger)rowNumber ; i++) {
        for (NSInteger j = 0; j<heightNum; j++) {
            SLGridView * grid = [[SLGridView alloc] initWithGridPosition:[SLGridPosition positionWithX:i andY:j]];
            grid.width = w;
            [self.map setValue:grid forKey:grid.gridPosition.stringForKey];
            [self addSubview:grid];
            
        }
    }
    [[self getCurrentController] viewDidLayoutSubviews];
    [SLGameConfig sharedInstance].userInternactionalForGame = YES;
}

// 布雷
-(void)releaseBoomIfNeedByFirstClick:(SLGridView *)firstClickGrid;
{
    
    if (self.hasReleaseBoom == NO) {
        [SLGameConfig sharedInstance].userInternactionalForGame = NO;
        NSLog(@"开始布雷");
        
        // 雷数
        NSInteger numberOfBooms = (NSInteger)(((double)self.map.allValues.count) / ((double)kBoomNumberPercent));
        
        NSArray * roundGrids = [self getAroundGridsByGrid:firstClickGrid];
        
        NSArray * filterArray = [self.map.allValues qmui_filterWithBlock:^BOOL(id  _Nonnull item) {
            if ([roundGrids containsObject:item] || [item isEqual:firstClickGrid]) {
                return NO;
            }else{
                return YES;
            }
        }];

        for (NSInteger i = 0; i<numberOfBooms; i++) {
            NSLog(@"正在布第%d个雷",(int)i);
            SLGridView * ramdomGrid = filterArray[arc4random()%filterArray.count];
            BOOL found = !ramdomGrid.hasBoom;
            while (found == NO) {
                NSLog(@"这个格是已经有雷了，继续抽另外一个");
                NSInteger ramdomIndex =  arc4random()%filterArray.count;
                NSLog(@"抽到index为%d",(int)ramdomIndex);
                ramdomGrid = filterArray[ramdomIndex];
                found = YES;
            }
            ramdomGrid.hasBoom = YES;
            NSLog(@"成功布下一雷");
        }

        [self configGridsBoomNumberAround];
        self.hasReleaseBoom = YES;
        NSLog(@"布雷完成");
        [[SLGameConfig sharedInstance] startGame];
        [SLGameConfig sharedInstance].userInternactionalForGame = YES;
    }
    
}


// 让各个格子知道旁边有几个炸弹
-(void)configGridsBoomNumberAround
{
    for (SLGridView * grid_a in self.map.allValues) {
        
        NSInteger numberOfBoomAround = 0;
        for (SLGridView * grid_b in [self getAroundGridsByGrid:grid_a]) {
            numberOfBoomAround += grid_b.hasBoom?1:0;
        }
        
        grid_a.boomNumberAround = numberOfBoomAround;
    }
}

// 通过一个格子拿到它周围的格子
-(NSArray <SLGridView *>*)getAroundGridsByGrid:(SLGridView *)grid
{
    NSMutableArray * temp = [NSMutableArray array];
    NSArray * configX = @[@(-1),@(0),@(1)];
    NSArray * configY = @[@(-1),@(0),@(1)];
    for (id obj_x in configX) {
        for (id obj_y in configY) {
            NSInteger c_x = [obj_x integerValue];
            NSInteger c_y = [obj_y integerValue];
            if ((c_x == 0 && c_y == 0) == NO) { // 不同时等于0的情况下
                NSInteger x = grid.gridPosition.x + c_x;
                NSInteger y = grid.gridPosition.y + c_y;
                if ( ((x >= 0) && (x < self.rowNumber)) && ((y>=0) && (y<self.lineNumber))) {
                    // 符合条件
                    SLGridPosition * thisPosition = [SLGridPosition positionWithX:x andY:y];
                    SLGridView * thisGrid = [self.map objectForKey:thisPosition.stringForKey];
                    [temp addObject:thisGrid];
                }
            }
        }
    }
    return temp;
}

// 扫周边的雷
-(void)sweepAroundByGrid:(SLGridView *)grid
{
    NSArray <SLGridView *>* aroundGrid = [self getAroundGridsByGrid:grid];
    
    [aroundGrid enumerateObjectsUsingBlock:^(SLGridView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == SLGridStatusDefault) {
            [obj openGrid];
        }
    }];
}

// 检查游戏进程
-(void)checkGameProgress
{
    if (self.hasReleaseBoom == NO) {
        return;
    }
    NSMutableArray * gridsWithoutBoom = [NSMutableArray array];
    for (SLGridView * grid in self.map.allValues) {
        if (grid.hasBoom == NO) {
            [gridsWithoutBoom addObject:grid];
        }
    }
    BOOL gameSuccessed = YES;
    for (SLGridView * gridWithoutBoom in gridsWithoutBoom) {
        if (gridWithoutBoom.status != SLGridStatusOpened) {
            gameSuccessed = NO;
            break;
        }
    }
    
    if (gameSuccessed) {
        // 赢了 游戏结束
        [[SLGameConfig sharedInstance] endGame];
        NSTimeInterval gameTime = [SLGameConfig sharedInstance].gameTime;
        long min = (long)(gameTime/60);
        long second = ((long)(gameTime))%60;
        NSString * timeStr = [NSString stringWithFormat:@"%lds%ldm",min,second];
        
        // 保存记录
        SLRecord * record = [SLRecord new];
        record.gameTime = gameTime;
        record.hardLevel = [SLGameConfig sharedInstance].hardLevel;
        [record save];
        
        BOOL hasNewRecord = NO;
        NSArray * recordList = [SLRecord recordListWithHardLevel:[SLGameConfig sharedInstance].hardLevel];
        if (recordList.count>0) {
            SLRecord * firstRecord = [recordList firstObject];
            if (record.gameTime < firstRecord.gameTime) {
                hasNewRecord = YES;
            }
        }else{
            hasNewRecord = YES;
        }
        
        NSString * msg = hasNewRecord?[NSString stringWithFormat:@"Congratulations on your new record!Total time:%@",timeStr]:[NSString stringWithFormat:@"Congratulations！Total Time:%@",timeStr];
        [SLAlertTool showAlertWithMainColor:SLColorNavigationBar andTitle:@"You Win!!!" andMsg:msg andBtnTitle:@"Again" andBtnHandler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [self generateGripMap];
        }];

        
    }else{
        NSLog(@"游戏还未完");
    }
    
    
}

#pragma mark - lazy
// 根据难度级别配置放个数目
- (NSDictionary *)levelInfo
{
    if (!_levelInfo) {
        _levelInfo = @{[NSString stringWithFormat:@"%ld",(long)SLHardLevelEasy]:@"6",
                       [NSString stringWithFormat:@"%ld",(long)SLHardLevelMediem]:@"10",
                       [NSString stringWithFormat:@"%ld",(long)SLHardLevelHard]:@"13",
        };
    }
    return _levelInfo;
}

- (NSMutableDictionary *)map
{
    if (!_map) {
        _map = [NSMutableDictionary dictionary];
    }
    return _map;
}

- (SLControlToolView *)toolView
{
    if (!_toolView) {
        _toolView = [[SLControlToolView alloc] init];
        _toolView.hidden = YES;
        [self addSubview:_toolView];
    }
    return _toolView;
}

@end
