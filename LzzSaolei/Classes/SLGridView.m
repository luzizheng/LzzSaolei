//
//  SLGridView.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/14.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLGridView.h"


@implementation SLGridPosition

+(instancetype)positionWithX:(NSInteger)x andY:(NSInteger)y
{
    SLGridPosition * p = [[SLGridPosition alloc] init];
    p.x=x;
    p.y=y;
    return p;
}

- (NSString *)stringForKey
{
    return [NSString stringWithFormat:@"%d-%d",(int)self.x,(int)self.y];
}

@end

@interface SLGridView()

@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIView * maskShall;
@property(nonatomic,strong)NSDictionary * colorWithNumber;

@property(nonatomic,strong)UIImageView * boomImageView;

@property(nonatomic,strong)UIImageView * flagImageView;

@property(nonatomic,assign)NSInteger openIndex;

@property(nonatomic,strong)NSTimer * openTimer;

@end

@implementation SLGridView
@synthesize gridPosition = _gridPosition;


- (void)dealloc
{
    NSLog(@"SLGridView销毁");
}

-(instancetype)initWithGridPosition:(SLGridPosition *)gridPosition
{
    if (self = [super init]) {
        self.gridPosition = gridPosition;
        self.status = SLGridStatusDefault;
        self.hasBoom = NO;
        
    }
    return self;
}

- (void)setHasBoom:(BOOL)hasBoom{
    _hasBoom = hasBoom;
    self.boomImageView.hidden = !hasBoom;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.actionBtn.frame = self.bounds;
    self.boomImageView.frame = self.bounds;
    self.label.frame = self.bounds;
    self.maskShall.frame = self.bounds;
    self.flagImageView.frame = self.bounds;
}


- (void)setGridPosition:(SLGridPosition *)gridPosition
{
    _gridPosition = gridPosition;
    self.maskShall.backgroundColor = ((gridPosition.x + gridPosition.y)%2 == 0)?SLColorGridMaskDark:SLColorGridMaskLight;
    self.backgroundColor = ((gridPosition.x + gridPosition.y)%2 == 0)?SLColorGridBackgroundDark:SLColorGridBackgroundLight;
}

// 单击和双击的处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([SLGameConfig sharedInstance].userInternactionalForGame == NO) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showControlToolView) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonRepeatAction) object:nil];
        return;
    }
    UITouch * touch = [touches anyObject];
    NSTimeInterval delay =0.1;
    if (touch.tapCount == 1) {
        [self performSelector:@selector(showControlToolView) withObject:nil afterDelay:delay];
    }else if (touch.tapCount == 2){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showControlToolView) object:nil];
        [self performSelector:@selector(buttonRepeatAction) withObject:nil afterDelay:delay];
    }
}

// 单击操作
-(void)showControlToolView
{
    if (self.status == SLGridStatusDefault || self.status == SLGridStatusFlag) {
        self.targetMap.toolView.sourceGrid = self;
    }else if (self.status == SLGridStatusOpened){
        
        if (self.boomNumberAround == 0) {
            self.targetMap.toolView.hidden = YES;
        }else{
            
            // 扫周边
            if (self.canSweepAround) {
                self.targetMap.toolView.sourceGrid = self;
            }else{
                self.targetMap.toolView.hidden = YES;
            }
        }
    }
    
}

// 双击操作
- (void)buttonRepeatAction
{
    if (self.status == SLGridStatusDefault) {
        self.targetMap.toolView.hidden = YES;
        [self openGrid];
    }else if(self.status == SLGridStatusOpened){
        self.targetMap.toolView.hidden = YES;
        
        // 扫周边
        if (self.canSweepAround) {
            [self.targetMap sweepAroundByGrid:self];
        }
        
    }
}

// 检测是否可以扫周边
- (BOOL)canSweepAround
{
    BOOL flag = NO;
    if (self.status == SLGridStatusOpened) {
        NSInteger flagNum = 0;
        for (SLGridView * g in [self.targetMap getAroundGridsByGrid:self]) {
            if (g.status == SLGridStatusFlag) {
                flagNum += 1;
            }
        }
        if ((self.boomNumberAround > 0) && (self.boomNumberAround == flagNum)) {
            flag = YES;
        }
    }
    return flag;
}

- (void)setBoomNumberAround:(NSInteger)boomNumberAround
{
    _boomNumberAround = boomNumberAround;
    
    if (self.hasBoom) {
        self.label.text = nil;
    }else{
        NSString * numberString = [NSString stringWithFormat:@"%ld",(long)boomNumberAround];
        self.label.textColor = [self.colorWithNumber valueForKey:numberString];
        self.label.text = numberString;
    }
    
}

// 改变状态
- (void)setStatus:(SLGridStatus)status
{
    _status = status;
    if (status == SLGridStatusFlag) {
        self.flagImageView.hidden = NO;
        [self bringSubviewToFront:self.flagImageView];
    }else{
        self.flagImageView.hidden = YES;
    }
}


-(void)openGrid
{
    [self openGridWithShakeAnimate:YES];
}

-(void)openGridWithoutShakeAnimate
{
    [self openGridWithShakeAnimate:NO];
}

-(void)openGridWithShakeAnimate:(BOOL)shakeAnimate
{
    [self.targetMap releaseBoomIfNeedByFirstClick:self];
    
    if (self.status == SLGridStatusDefault || self.status == SLGridStatusFlag) {
        
        
        
        self.status = SLGridStatusOpened;
        
        self.maskShall.hidden = YES;
        [self boomWithColor:[self.maskShall.backgroundColor qmui_transitionToColor:UIColorBlack progress:0.3]];// 爆炸动画
        if (self.hasBoom) {
            // 炸了
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_touchBoom object:nil];
        }else{
            // 没炸弹 开
            
            
            // 如果周边都没炸弹，全开了
            if (self.boomNumberAround == 0) {
                if (shakeAnimate) {
                    [self.targetMap shakeAnimate];
                }
                [[SLAudioTool sharedInstance] playAudioWithFileName:@"audio_breakAround"];
                [self openGridWithTimeInterval:[self.targetMap getAroundGridsByGrid:self]];
                
            }else{
                [[SLAudioTool sharedInstance] playAudioWithFileName:@"audio_breakGrid"];
            }
        }
        [self.targetMap checkGameProgress];
    }
}

// 按时间间隔开雷
-(void)openGridWithTimeInterval:(NSArray <SLGridView *>*)grids
{
    __weak typeof(self)weakSelf = self;
    self.openIndex = 0;
    if (self.openTimer) {
        [self.openTimer invalidate];
        self.openTimer = nil;
    }
    self.openTimer = [NSTimer timerWithTimeInterval:0.1 target:weakSelf selector:@selector(openGridByIndex:) userInfo:@{@"array":grids} repeats:YES];
    [self.openTimer fireDate];
    [[NSRunLoop mainRunLoop] addTimer:self.openTimer forMode:NSRunLoopCommonModes];
}

-(void)openGridByIndex:(NSTimer *)t
{
    NSArray *grids = [t.userInfo objectForKey:@"array"];
    
    if (self.openIndex >= grids.count) {
        [t invalidate];
        self.openIndex = 0;
    }else{
        SLGridView * thisGrid = [grids objectAtIndex:self.openIndex];
        [thisGrid openGridWithoutShakeAnimate];
        self.openIndex +=1;
    }
}


-(void)gameOverShowBoomOut
{
    if (self.hasBoom) {
        UIColor * color = [UIColor qmui_randomColor];
        [self boomWithColor:color];
        self.maskShall.hidden = YES;
        self.flagImageView.hidden = YES;
        self.boomImageView.hidden = NO;
        self.label.hidden = YES;
        self.backgroundColor = color;
    }
    
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    }
    return _label;
}

- (UIView *)maskShall
{
    if (!_maskShall) {
        _maskShall = [[UIView alloc] init];
        _maskShall.userInteractionEnabled = NO;
        [self addSubview:self.label];
        [self insertSubview:self.boomImageView aboveSubview:self.label];
        [self insertSubview:_maskShall aboveSubview:self.boomImageView];
    }
    return _maskShall;
}

- (NSDictionary *)colorWithNumber
{
    if (!_colorWithNumber) {
        _colorWithNumber = @{@"0":[UIColor clearColor],
                             @"1":[UIColor qmui_colorWithHexString:@"1379d8"],
                             @"2":[UIColor qmui_colorWithHexString:@"3b8c38"],
                             @"3":[UIColor qmui_colorWithHexString:@"d52c2c"],
                             @"4":[UIColor qmui_colorWithHexString:@"853f04"],
                             @"5":[UIColor qmui_colorWithHexString:@"b76f40"],
                             @"6":[UIColor qmui_colorWithHexString:@"2b6447"],
                             @"7":[UIColor qmui_colorWithHexString:@"472d56"],
                             @"8":[UIColor qmui_colorWithHexString:@"f3715c"]
        };
    }
    return _colorWithNumber;
}

- (UIImageView *)boomImageView
{
    if (!_boomImageView) {
        _boomImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"boom")];
        _boomImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _boomImageView;
}

- (SLGridMap *)targetMap
{
    if (self.superview) {
        if ([self.superview isKindOfClass:[SLGridMap class]]) {
            return (SLGridMap *)self.superview;
        }
    }
    return nil;
}

- (SLGridPosition *)gridPosition
{
    if (!_gridPosition) {
        _gridPosition = [SLGridPosition positionWithX:0 andY:0];
    }
    return _gridPosition;
}

- (UIImageView *)flagImageView
{
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"red_flag")];
        _flagImageView.contentMode = UIViewContentModeScaleAspectFit;
        _flagImageView.hidden = YES;
        [self addSubview:_flagImageView];
    }
    return _flagImageView;
}

@end
