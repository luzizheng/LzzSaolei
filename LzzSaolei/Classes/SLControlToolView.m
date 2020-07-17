//
//  SLControlToolView.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/15.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLControlToolView.h"
#import "SLGridView.h"


typedef NS_ENUM(NSInteger,ToolDirection) {
    ToolDirectionLeftTop,
    ToolDirectionRightTop,
    ToolDirectionLeftBottom,
    ToolDirectionRightBottom
};

@interface SLControlToolView()
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * flagBtn;
@property(nonatomic,strong)UIButton * shovelBtn;
@property(nonatomic,strong)CALayer * borderLayer;

@property(nonatomic,assign)ToolDirection menuDirection;
@end

@implementation SLControlToolView

-(CGFloat)getToolWidth
{
    return self.sourceGrid?((self.sourceGrid.qmui_width + 10) * 2):100.0;
}

-(CGFloat)getMenuWidth
{
    return self.sourceGrid?(self.sourceGrid.qmui_width + 10):40.0;
}


- (instancetype)init
{
    self = [super initWithFrame:CGRectMakeWithSize(CGSizeMake(100, 100))];
    if (self) {
        UIColor * maskColor = [SLColorControlToolTin colorWithAlphaComponent:0.3];
        self.cancelBtn = [[UIButton alloc] init];
        self.cancelBtn.layer.backgroundColor = maskColor.CGColor;
        [self.cancelBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"\U0000e794" attributes:@{NSFontAttributeName:[CHEMMIconFont fontWithSize:25],NSForegroundColorAttributeName:UIColorWhite}] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        
        self.flagBtn = [[UIButton alloc] init];
        self.flagBtn.layer.backgroundColor = maskColor.CGColor;
        [self.flagBtn setImage:UIImageMake(@"red_flag") forState:UIControlStateNormal];
        [self.flagBtn addTarget:self action:@selector(flagBtnBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.flagBtn];
        
        self.shovelBtn = [[UIButton alloc] init];
        self.shovelBtn.layer.backgroundColor = maskColor.CGColor;
        [self.shovelBtn setImage:UIImageMake(@"shovel") forState:UIControlStateNormal];
        [self.shovelBtn addTarget:self action:@selector(openGridAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shovelBtn];
        
        
        self.borderLayer = [CALayer layer];
        self.borderLayer.borderColor = maskColor.CGColor;
        self.borderLayer.borderWidth = 4;
        [self.layer addSublayer:self.borderLayer];
        
        
        
    }
    return self;
}

- (void)setSourceGrid:(SLGridView *)sourceGrid
{
    _sourceGrid = sourceGrid;
    if (sourceGrid) {

        if (sourceGrid.status == SLGridStatusFlag) {
            self.flagBtn.hidden = YES;
            self.shovelBtn.hidden = YES;
        }else{
            if (sourceGrid.canSweepAround) {
                self.shovelBtn.hidden = NO;
                self.flagBtn.hidden = YES;
            }else{
                self.shovelBtn.hidden = NO;
                self.flagBtn.hidden = NO;
            }
        }
        
        
        CGFloat tool_w = [self getToolWidth];
        CGFloat grid_w = sourceGrid.qmui_width;
        CGFloat minDistace = tool_w - grid_w;
        CGPoint origin = CGPointZero;
        CGFloat left = sourceGrid.qmui_left;
        CGFloat top = sourceGrid.qmui_top;
        CGFloat right = sourceGrid.superview.qmui_width - sourceGrid.qmui_right;
        CGFloat bottom = sourceGrid.superview.qmui_height - sourceGrid.qmui_bottom;
        
        if (top >= minDistace && left >= minDistace) {
            NSLog(@"左上");
            self.menuDirection = ToolDirectionLeftTop;
            origin = CGPointMake(sourceGrid.qmui_left - (tool_w - grid_w), sourceGrid.qmui_top - (tool_w - grid_w));
        }else if (right >= minDistace && top >= minDistace) {
            NSLog(@"右上");
            self.menuDirection = ToolDirectionRightTop;
            origin = CGPointMake(sourceGrid.qmui_left, sourceGrid.qmui_top - (tool_w - grid_w));
        }else if (left >= minDistace && bottom >= minDistace) {
            NSLog(@"左下");
            self.menuDirection = ToolDirectionLeftBottom;
            origin = CGPointMake(sourceGrid.qmui_left - (tool_w - grid_w), sourceGrid.qmui_top);
        }else if (right >= minDistace && bottom >= minDistace) {
            NSLog(@"右上");
            self.menuDirection = ToolDirectionRightBottom;
            origin = CGPointMake(sourceGrid.qmui_left, sourceGrid.qmui_top);
        }else{
            NSLog(@"出错");
        }
        self.frame = CGRectMake(origin.x, origin.y, tool_w, tool_w);
        [self layoutSubviews];
        self.hidden = NO;
        [self.superview bringSubviewToFront:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.sourceGrid) {
        
        CGFloat menu_w = [self getMenuWidth];
        CGRect menuRect = CGRectMakeWithSize(CGSizeMake(menu_w, menu_w));
        self.cancelBtn.frame = menuRect;
        self.flagBtn.frame = menuRect;
        self.shovelBtn.frame = menuRect;
        self.cancelBtn.layer.cornerRadius = menu_w/2;
        self.flagBtn.layer.cornerRadius = menu_w/2;
        self.shovelBtn.layer.cornerRadius = menu_w/2;
        switch(self.menuDirection){
            case ToolDirectionLeftTop:
            {
                self.cancelBtn.qmui_left = 0;
                self.cancelBtn.qmui_top = 0;
                
                self.flagBtn.qmui_left = 0;
                self.flagBtn.qmui_top = self.qmui_height - menu_w;
                
                self.shovelBtn.qmui_left = self.qmui_width - menu_w;
                self.shovelBtn.qmui_top = 0;
                
                self.borderLayer.frame = CGRectMake(self.qmui_width - self.sourceGrid.qmui_width,self.qmui_height - self.sourceGrid.qmui_height, self.sourceGrid.qmui_width, self.sourceGrid.qmui_height);
            }
                break;
            case ToolDirectionRightTop:
            {
                self.cancelBtn.qmui_left = self.qmui_width - menu_w;
                self.cancelBtn.qmui_top = 0;
                
                self.flagBtn.qmui_left = self.qmui_width - menu_w;
                self.flagBtn.qmui_top = self.qmui_height - menu_w;
                
                self.shovelBtn.qmui_left = 0;
                self.shovelBtn.qmui_top = 0;
                
                self.borderLayer.frame = CGRectMake(0,self.qmui_height - self.sourceGrid.qmui_height, self.sourceGrid.qmui_width, self.sourceGrid.qmui_height);
            }
                break;
            case ToolDirectionLeftBottom:
            {
                self.cancelBtn.qmui_left = 0;
                self.cancelBtn.qmui_top = self.qmui_height - menu_w;
                
                self.flagBtn.qmui_left = self.qmui_width - menu_w;
                self.flagBtn.qmui_top = self.qmui_height - menu_w;
                
                self.shovelBtn.qmui_left = 0;
                self.shovelBtn.qmui_top = 0;
                
                self.borderLayer.frame = CGRectMake(self.qmui_width - self.sourceGrid.qmui_width,0, self.sourceGrid.qmui_width, self.sourceGrid.qmui_height);
            }
                break;
            case ToolDirectionRightBottom:
            {
                self.cancelBtn.qmui_left = self.qmui_width - menu_w;
                self.cancelBtn.qmui_top = self.qmui_height - menu_w;
                
                self.flagBtn.qmui_left = 0;
                self.flagBtn.qmui_top = self.qmui_height - menu_w;
                
                self.shovelBtn.qmui_left = self.qmui_width - menu_w;
                self.shovelBtn.qmui_top = 0;
                
                self.borderLayer.frame = CGRectMake(0,0, self.sourceGrid.qmui_width, self.sourceGrid.qmui_height);
            }
                break;
            default:
                break;
        }

        
        
        
    }
}



-(void)cancelBtnClickAction:(id)sender
{
    if (self.sourceGrid.status == SLGridStatusFlag) {
        self.sourceGrid.status = SLGridStatusDefault;
    }
    self.hidden = YES;
    
}

-(void)flagBtnBtnClickAction:(id)sender
{
    if (self.sourceGrid.status == SLGridStatusDefault) {
        [[SLAudioTool sharedInstance] playAudioWithFileName:@"audio_flag"];
        self.sourceGrid.status = SLGridStatusFlag;
    }
    self.hidden = YES;
}

-(void)openGridAction:(id)sender
{
    if (self.sourceGrid.canSweepAround) {
        [self.sourceGrid.targetMap sweepAroundByGrid:self.sourceGrid];
    }else{
       [self.sourceGrid openGrid];
    }
    self.hidden = YES;
}


// 为了让不点到按钮的时候，事件能穿过去继续点到下面的格子
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[self class]]) {
        return nil;
    }
    return view;
}




@end
