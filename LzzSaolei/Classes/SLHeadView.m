//
//  SLHeadView.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLHeadView.h"
#import "SLGameRecordView.h"
@interface SLHeadView()

@property(nonatomic,strong)CALayer * bottomLine;

@property(nonatomic,strong)UIButton * levelBtn;

@property(nonatomic,strong)NSDictionary * levelTitle;

@property(nonatomic,strong)UIButton * timeLabel;

@property(nonatomic,strong)QMUIPopupMenuView * menu;

@property(nonatomic,strong)UIButton * soundBtn;

@property(nonatomic,strong)SLGameRecordView * recordView;

@end

@implementation SLHeadView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.backgroundColor = SLColorNavigationBar;
        self.bottomLine = [CALayer layer];
        self.bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        [self.layer addSublayer:self.bottomLine];
        
        
        self.levelBtn = [[UIButton alloc] initWithFrame:CGRectMakeWithSize(CGSizeMake(80, 32))];
        [self.levelBtn addTarget:self action:@selector(levelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.levelBtn setBackgroundImage:[UIImage qmui_imageWithColor:[UIColor colorWithWhite:1 alpha:0.1] size:self.levelBtn.frame.size cornerRadius:0] forState:UIControlStateNormal];
        [self addSubview:self.levelBtn];
        
        
        self.timeLabel = [[UIButton alloc] init];
        [self.timeLabel addTarget:self action:@selector(timeLabelClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.timeLabel];
        
        [self updateLevelTitle];
        
        
        self.soundBtn = [[UIButton alloc] init];
        [self.soundBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"\U0000e605" attributes:@{NSFontAttributeName:[CHEMMIconFont fontWithCarChatting:20],NSForegroundColorAttributeName:SLColorNavigationBarTin}] forState:UIControlStateNormal];
        [self.soundBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"\U0000e604" attributes:@{NSFontAttributeName:[CHEMMIconFont fontWithCarChatting:20],NSForegroundColorAttributeName:SLColorNavigationBarTin}] forState:UIControlStateSelected];
        [self.soundBtn addTarget:self action:@selector(soundBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.soundBtn.selected = ![SLGameConfig sharedInstance].openSound;
        
        [self addSubview:self.soundBtn];
        
        [[SLGameConfig sharedInstance] addObserver:self forKeyPath:@"openSound" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        
        [[SLGameConfig sharedInstance] addObserver:self forKeyPath:@"gameTime" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[SLGameConfig sharedInstance] removeObserver:self forKeyPath:@"openSound"];
    [[SLGameConfig sharedInstance] removeObserver:self forKeyPath:@"gameTime"];
}

-(void)timeLabelClickAction:(id)sender
{
    [self.recordView showWithAnimated:YES];
}

-(void)soundBtnClickAction:(UIButton *)sender
{
    [SLGameConfig sharedInstance].openSound = sender.selected;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"openSound"]) {
        BOOL value = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.soundBtn.selected = !value;
    }
    
    if ([keyPath isEqualToString:@"gameTime"]) {
        NSTimeInterval gameTime = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self updateGameTimeLabel:gameTime];
    }
    
}



-(void)updateGameTimeLabel:(NSTimeInterval)gameTime;
{
    long min = (long)(gameTime/60);
    long second = ((long)(gameTime))%60;
    NSString * timeStr = [NSString stringWithFormat:@"%ld:%ld",min,second];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString * str_a = [[NSAttributedString alloc] initWithString:@"\U0000e781" attributes:@{NSFontAttributeName:[CHEMMIconFont fontWithCarChatting:20],NSForegroundColorAttributeName:SLColorNavigationBarTin}];
    NSAttributedString * str_b = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",timeStr] attributes:@{NSFontAttributeName:SLFont(17),NSForegroundColorAttributeName:SLColorNavigationBarTin}];
    [str appendAttributedString:str_a];
    [str appendAttributedString:str_b];
    
    [self.timeLabel setAttributedTitle:str forState:UIControlStateNormal];
    
    [self layoutTimeContent];
}

-(void)updateLevelTitle
{
    NSString * title = self.levelTitle[[NSString stringWithFormat:@"%ld",(long)[SLGameConfig sharedInstance].hardLevel]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    NSAttributedString * str_a = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",title] attributes:@{NSFontAttributeName:SLFont(13),NSForegroundColorAttributeName:SLColorNavigationBarTin}];
    NSAttributedString * str_b = [[NSAttributedString alloc] initWithString:@"\U0000e78a" attributes:@{NSFontAttributeName:[CHEMMIconFont fontWithSize:12],NSForegroundColorAttributeName:SLColorNavigationBarTin}];
    [str appendAttributedString:str_a];
    [str appendAttributedString:str_b];
    [self.levelBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat contentHeight = self.qmui_height - StatusBarHeight;
    
    self.levelBtn.qmui_left = 15;
    self.levelBtn.qmui_top = StatusBarHeight + (contentHeight- self.levelBtn.qmui_height)/2;
    [self layoutTimeContent];
    
    
    CGFloat soundBtn_w = contentHeight * 3/4;
    
    self.soundBtn.frame = CGRectMake(self.qmui_width - 15 - soundBtn_w, StatusBarHeight + (contentHeight - soundBtn_w)/2, soundBtn_w, soundBtn_w);
    
    CGFloat lineWidth = 0.5;
    self.bottomLine.frame = CGRectMake(0, self.qmui_height - lineWidth, self.qmui_width, lineWidth);
    
}

-(void)layoutTimeContent
{
    CGFloat contentHeight = self.qmui_height - StatusBarHeight;
    CGSize timeTextSize = self.timeLabel.currentAttributedTitle.size;
   
    self.timeLabel.frame = CGRectMakeWithSize(timeTextSize);
    self.timeLabel.center = CGPointMake(self.qmui_width/2, StatusBarHeight + contentHeight/2);
}


-(void)levelBtnClickAction:(id)sender
{
    [self.menu showWithAnimated:YES];
}

- (NSDictionary *)levelTitle
{
    if (!_levelTitle) {
        _levelTitle = @{[NSString stringWithFormat:@"%ld",(long)SLHardLevelEasy]:@"Easy",
                       [NSString stringWithFormat:@"%ld",(long)SLHardLevelMediem]:@"Normal",
                       [NSString stringWithFormat:@"%ld",(long)SLHardLevelHard]:@"Crazy"
        };
    }
    return _levelTitle;
}
- (QMUIPopupMenuView *)menu
{
    if (!_menu) {
        _menu = [[QMUIPopupMenuView alloc] init];
        _menu.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _menu.itemTitleColor = SLColorNavigationBar;
        _menu.itemTitleFont = SLFont(15);
        _menu.maskViewBackgroundColor = UIColorMask;
        _menu.shouldShowItemSeparator = YES;
        __weak __typeof(self)weakSelf = self;
        _menu.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            aItem.button.highlightedBackgroundColor = [weakSelf.backgroundColor colorWithAlphaComponent:.2];

        };
        _menu.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:self.levelTitle[[NSString stringWithFormat:@"%ld",(long)SLHardLevelEasy]] handler:^(QMUIPopupMenuButtonItem *aItem) {
            [SLGameConfig sharedInstance].hardLevel = SLHardLevelEasy;
            [aItem.menuView hideWithAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_regenerateMap object:nil];
            
        }],
                                     [QMUIPopupMenuButtonItem itemWithImage:nil title:self.levelTitle[[NSString stringWithFormat:@"%ld",(long)SLHardLevelMediem]] handler:^(QMUIPopupMenuButtonItem *aItem) {
                                         [SLGameConfig sharedInstance].hardLevel = SLHardLevelMediem;
                                         [aItem.menuView hideWithAnimated:YES];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_regenerateMap object:nil];
                                     }],
                                     [QMUIPopupMenuButtonItem itemWithImage:nil title:self.levelTitle[[NSString stringWithFormat:@"%ld",(long)SLHardLevelHard]] handler:^(QMUIPopupMenuButtonItem *aItem) {
                                         [SLGameConfig sharedInstance].hardLevel = SLHardLevelHard;
                                         [aItem.menuView hideWithAnimated:YES];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_regenerateMap object:nil];
                                     }]];
        _menu.didHideBlock = ^(BOOL hidesByUserTap) {
            [weakSelf updateLevelTitle];
            
        };
        _menu.sourceView = self.levelBtn;// 相对于 button4 布局
        
    }
    return _menu;
}

- (SLGameRecordView *)recordView
{
    if (!_recordView) {
        _recordView = [[SLGameRecordView alloc] init];
        _recordView.sourceView = self.timeLabel;
    }
    return _recordView;
}


@end
