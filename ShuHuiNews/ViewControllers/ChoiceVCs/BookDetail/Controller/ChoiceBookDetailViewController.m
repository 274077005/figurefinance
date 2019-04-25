//
//  ChoiceBookDetailViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/11.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "ChoiceBookDetailViewController.h"
#import "BookDetailMenuViewController.h"
#import "BookDetailAlikeViewController.h"
#import "BookDetailIntroViewController.h"
#import "FDSlideBar.h"
#import "GestureTableView.h"
#import "FloatContainerCell.h"
#import "FloatTableCell.h"
#import "BookDetailHeaderView.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface ChoiceBookDetailViewController ()<UITableViewDataSource,UITableViewDelegate,FloatContainerCellDelegate>
//书籍作者cell
@property (nonatomic,strong) FloatContainerCell *containerCell;
//滚动模块
@property (nonatomic,strong) FDSlideBar *sliderView;

@property (nonatomic,assign) BOOL canScroll;
//tableView 父视图
@property (nonatomic,strong) GestureTableView *tableView;
//书籍介绍视图
@property (nonatomic,strong) BookDetailHeaderView *bookDetailHeaderView;

@end

@implementation ChoiceBookDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"书籍详情";
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏右侧按钮
    [self rightItemView];
    //设置主视图
    [self setTable];
    //底部按钮
    [self bottomView];
    self.canScroll = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
}

- (void)changeScrollStatus{
    self.canScroll = YES;
    self.containerCell.objectCanScroll = NO;
}

#pragma mark view
- (void)rightItemView
{
    UIButton *videoButton = [self createBtnItemImageName:@"video_icon"];
    UIBarButtonItem *videoItem = [[UIBarButtonItem alloc] initWithCustomView:videoButton];
    
    UIButton *musicButton = [self createBtnItemImageName:@"music_icon"];
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithCustomView:musicButton];
    
    UIButton *shareButton = [self createBtnItemImageName:@"share_icon"];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

    self.navigationItem.rightBarButtonItems = @[shareItem,musicItem,videoItem];
}
- (UIButton *)createBtnItemImageName:(NSString *)image
{
    UIButton *Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [Button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return Button;
   
}
- (void)itemBtnClicked:(UIButton *)sender
{
    
}
- (void)setTable{
    [self.view addSubview:self.tableView];
    _bookDetailHeaderView = [[BookDetailHeaderView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    _bookDetailHeaderView.backgroundColor = [UIColor whiteColor];
    _bookDetailHeaderView.dataAry = @[@"",@"",@"",@"",@"",@""];
    _tableView.tableHeaderView=_bookDetailHeaderView;
}

- (void)bottomView
{
    CGFloat height = iphoneX?(34):0;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45-height, SCREEN_WIDTH, 45)];
    bottomView.backgroundColor = RGBCOLOR(237, 237, 237);
    [self.view addSubview:bottomView];
    //免费试读  按钮
    UIButton *freeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 44)];
    freeBtn.backgroundColor = [UIColor whiteColor];
    [freeBtn setTitleColor:RGBCOLOR(40, 40, 40) forState:UIControlStateNormal];
    [freeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [freeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [freeBtn setTitle:@"免费试读" forState:UIControlStateNormal];
    [freeBtn addTarget:self action:@selector(freeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:freeBtn];
    
    //立即购买 按钮
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,0, SCREEN_WIDTH/2, 44)];
    buyBtn.backgroundColor = RGBCOLOR(35, 122, 229);
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [buyBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    
}
- (void)freeBtnClick:(UIButton *)freeBtn
{
    
}
- (void)buyBtnClick:(UIButton *)buyBtn
{
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {//第一cell
            
        }else{//第二cell
            
        }
    }
}


#pragma mark ——————————UIScrollViewDelegate——————————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat bottomCellOffset1 = [self.tableView rectForSection:1].origin.y;
        CGFloat bottomCellOffset = _bookDetailHeaderView.height+90;
        bottomCellOffset = floorf(bottomCellOffset);
        
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                self.containerCell.objectCanScroll = YES;
            }
        }else{
            //子视图没到顶部
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}
#pragma mark ——————————UIScrollViewDelegate——————————


#pragma mark ——————————FloatContainerCellDelegate——————————
- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView{
    self.tableView.scrollEnabled = NO;
}

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    [UIView animateWithDuration:0.5 animations:^{
        [self.sliderView selectSlideBarItemAtIndex:page];
    }];
    
    self.tableView.scrollEnabled = YES;
}
#pragma mark ——————————FloatContainerCellDelegate——————————

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        FloatTableCell *clientCell=[tableView dequeueReusableCellWithIdentifier:@"float"];
        if (clientCell==nil) {
            clientCell=[[[NSBundle mainBundle]loadNibNamed:@"FloatTableCell" owner:self options:nil]lastObject];
        }
        clientCell.clipsToBounds=YES;
        clientCell.selectionStyle=UITableViewCellSelectionStyleNone;
        clientCell.tag=indexPath.row;
        
        return clientCell;
    }
    FloatContainerCell *contain=[tableView dequeueReusableCellWithIdentifier:@"container"];
    contain=[[FloatContainerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"container"];
    contain.VC=self;
    self.containerCell=contain;
    contain.delegate=self;
    return contain;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }
    return SCREEN_WINDOW_HEIGHT-sliderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return sliderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return self.sliderView;
    }
    return nil;
}


- (GestureTableView *)tableView{
    if (!_tableView) {
        CGFloat height = iphoneX?(TopHeight+34):TopHeight;
        CGRect tableFrame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - height);
        _tableView=[[GestureTableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];//group/plain都可
        if (self.hidesBottomBarWhenPushed == YES) {
            tableFrame.size.height = tableFrame.size.height + TabBarHeight;
        }
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.sectionFooterHeight=0;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}



- (FDSlideBar *)sliderView{//滑块部分可任意替换
    if (!_sliderView) {
        NSArray *itemArr = @[@"简介",@"目录",@"相似作品"];
        _sliderView = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _sliderView.backgroundColor = [UIColor whiteColor];
        _sliderView.itemsWidth=SCREEN_WIDTH/itemArr.count;
        _sliderView.itemsTitle = itemArr;
        _sliderView.itemFontSize = 15;
        _sliderView.itemColor = RGBCOLOR(166, 166, 166);
        _sliderView.itemSelectedColor = [UIColor blackColor];
        _sliderView.sliderColor = [UIColor whiteColor];
        [_sliderView slideBarItemSelectedCallback:^(NSUInteger idx) {
            [UIView animateWithDuration:0.5 animations:^{
                self.containerCell.isSelectIndex = YES;
                [self.containerCell.scrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
            }];
        }];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH-30, 1)];
        line.backgroundColor = RGBCOLOR(237, 237, 237);
        [_sliderView addSubview:line];
    }
    return _sliderView;
}



@end
