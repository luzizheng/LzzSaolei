//
//  SLGameRecordView.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/16.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLGameRecordView.h"

@interface SLGameRecordView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISegmentedControl * seg;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UILabel * emptyDatalabel;

@property(nonatomic,strong)NSArray <SLRecord *>* currentDisplayArray;
@end

@implementation SLGameRecordView

#define kPopWidth (SCREEN_WIDTH*3/4)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.currentDisplayArray = [NSArray array];
        
        self.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        self.maskViewBackgroundColor = UIColorMask;
        self.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        
        self.seg = [[UISegmentedControl alloc] initWithItems:@[@"Easy",@"Normal",@"Crazy"]];
        [self.seg setTitleTextAttributes:@{NSFontAttributeName:SLFont(15)} forState:UIControlStateNormal];
        [self.seg setTitleTextAttributes:@{NSFontAttributeName:SLFont(15)} forState:UIControlStateSelected];
        self.seg.tintColor = SLColorNavigationBar;
        
        if (IOS13_SDK_ALLOWED) {
            [self.seg setTitleTextAttributes:@{NSFontAttributeName:SLFont(15),NSForegroundColorAttributeName:SLColorGridMaskLight} forState:UIControlStateNormal];
            [self.seg setTitleTextAttributes:@{NSFontAttributeName:SLFont(15),NSForegroundColorAttributeName:SLColorGridMaskDark} forState:UIControlStateSelected];
        }
        
        [self.seg addTarget:self action:@selector(segDidChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.seg];
        
        self.emptyDatalabel = [[UILabel alloc] qmui_initWithFont:SLFont(15) textColor:SLColorNavigationBar];
        self.emptyDatalabel.textAlignment = NSTextAlignmentCenter;
        self.emptyDatalabel.text = @"No Records";
        [self.contentView addSubview:self.emptyDatalabel];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorColor = [UIColor clearColor];
        [self.contentView insertSubview:self.tableView aboveSubview:self.emptyDatalabel];
        
        [[SLGameConfig sharedInstance] addObserver:self forKeyPath:@"hardLevel" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hardLevel"]) {
        NSInteger value = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        self.seg.selectedSegmentIndex = value;
    }
}

-(void)segDidChanged:(UISegmentedControl *)sender
{
    SLHardLevel level = sender.selectedSegmentIndex;
    self.currentDisplayArray = [SLRecord recordListWithHardLevel:level];
    [self.tableView reloadData];
}

- (void)setCurrentDisplayArray:(NSArray<SLRecord *> *)currentDisplayArray
{
    _currentDisplayArray = currentDisplayArray;
    if (currentDisplayArray) {
        if (currentDisplayArray.count>0) {
            self.tableView.hidden = NO;
            return;
        }
    }
    self.tableView.hidden = YES;
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size
{
    return CGSizeMake(kPopWidth, kPopWidth*5/4);
}


- (void)showWithAnimated:(BOOL)animated
{
    [super showWithAnimated:animated];
    
    self.currentDisplayArray = [SLRecord recordListWithHardLevel:self.seg.selectedSegmentIndex];
    
    [self.tableView reloadData];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.seg.qmui_top = 15;
    self.seg.center = CGPointMake(self.contentView.qmui_width/2, self.seg.center.y);
    self.tableView.frame = CGRectMake(0, self.seg.qmui_bottom + 15, self.contentView.qmui_width, self.contentView.qmui_height - self.seg.qmui_bottom - 30);
    [self.emptyDatalabel sizeToFit];
    self.emptyDatalabel.center = self.tableView.center;
}

#pragma mark - table view delegate/datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentDisplayArray?self.currentDisplayArray.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = SLFont(15);
        cell.textLabel.textColor = SLColorGridBackgroundDark;
    }
    if (self.currentDisplayArray) {
        if (indexPath.row < self.currentDisplayArray.count) {
            SLRecord * thisRecord = [self.currentDisplayArray objectAtIndex:indexPath.row];
            NSString * rankStr = [NSString stringWithFormat:@"%ld.",(long)indexPath.row+1];
            NSString * userName = thisRecord.userName;
            long min = (long)(thisRecord.gameTime/60);
            long second = ((long)(thisRecord.gameTime))%60;
            NSString * timeStr = [NSString stringWithFormat:@"：%ldm%lds",min,second];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",rankStr,userName,timeStr];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
