//
//  AudioViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/12.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "AudioViewController.h"
#import "AudioDetailIntroViewController.h"
#import "AudioDetailMenuViewController.h"
#import "AudioDetailAlikeViewController.h"
#import "FDSlideBar.h"
#import "GestureTableView.h"
//#import "FloatContainerCell.h"
#import "FloatTableCell.h"
#import "BookDetailHeaderView.h"
#import "AudioDetailHeaderView.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)
#import "MusicViewController.h"
#import "AudioFloatContainerCell.h"
#import "AudioFloatTableCell.h"


@interface AudioViewController ()<UITableViewDataSource,UITableViewDelegate,FloatContainerCellDelegate>
//书籍作者cell
@property (nonatomic,strong) AudioFloatContainerCell *containerCell;
//滚动模块
@property (nonatomic,strong) FDSlideBar *sliderView;

@property (nonatomic,assign) BOOL canScroll;
//tableView 父视图
@property (nonatomic,strong) GestureTableView *tableView;

//书籍介绍视图
@property (nonatomic,strong) BookDetailHeaderView *bookDetailHeaderView;
@property (nonatomic,strong) AudioDetailHeaderView *audioDetailHeaderView;
@property (nonatomic,strong) NSDictionary *userInfoDict;
@property (nonatomic,strong) NSDictionary *dataDict;
@end

@implementation AudioViewController

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"音频详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightItemView];
    
    //设置主视图
    [self setTable];
    [self addBottomView];
    
    //读取缓存
    [self readCache];
    
    [self getData];
    
    self.canScroll = YES;
    [self initUiWithData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    //获取初始化音频
    //[self getFirstAudio];
    
    
}

- (void)getFirstAudio {
    //读取第一章节的音频
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSInteger num = [self.bookId integerValue];
    NSNumber *bookId = [NSNumber numberWithInteger:num];
    [bodyDic setObject:bookId forKey:@"book_id"];
    [bodyDic setObject:@1 forKey:@"p"];
    [bodyDic setObject:@10 forKey:@"limit"];
    NSNumber *type = [NSNumber numberWithInteger:self.type];
    [bodyDic setObject:type forKey:@"type"];
    
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JBookDetail Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.bookDetailDict = jsonDic[@"data"][@"bookDetail"];
                self.dataDict = jsonDic[@"data"];
                [UserDefaults setObject:self.bookDetailDict forKey:@"BookDetail"];
                [UserDefaults setObject:self.dataDict forKey:@"dataDetail"];
                //                dispatch_sync(dispatch_get_main_queue(), ^{
                [self initUiWithData];
                //                });
            }
        }else{
            
        }
    }];
}

- (void)changeScrollStatus{
    self.canScroll = YES;
    self.containerCell.objectCanScroll = NO;
}
- (void)setTable{
    [self.view addSubview:self.tableView];
    _audioDetailHeaderView = [[AudioDetailHeaderView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    _audioDetailHeaderView.backgroundColor = [UIColor whiteColor];
    //_audioDetailHeaderView.dataAry = @[@"",@"",@"",@"",@"",@""];
    _tableView.tableHeaderView=_audioDetailHeaderView;
}

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
- (void)readCache {
    NSDictionary *bookDetail = [UserDefaults dictionaryForKey:@"BookDetail"];
    NSDictionary *dataDict = [UserDefaults dictionaryForKey:@"dataDetail"];
    if(dataDict!=nil){
        self.dataDict = dataDict;
    }
    if (bookDetail==nil) {

    }else {
        self.bookDetailDict = bookDetail;
        [self initUiWithData];
    }
 

}

- (void)initUiWithData{
    NSDictionary *userInfoDict = self.bookDetailDict[@"userInfo"];
    _userInfoDict = userInfoDict;
    //[self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfoDict[@"image"]]];
//    self.nameLabel.text = userInfoDict[@"nickname"];
//    self.focusLabel.text = [NSString stringWithFormat:@"%@关注", userInfoDict[@"fens_num"]];
    [self.tableView reloadData];
    //判断是否已关注作者
    
    //判断作品是否已经购买
    if([self.bookDetailDict[@"isPay"] integerValue] == 0){
        
    }else {
        //已购买
        self.priceButton.backgroundColor = [UIColor grayColor];
        [self.priceButton setTitle:@"已购买" forState:UIControlStateNormal];
        self.priceButton.userInteractionEnabled = NO;
        
    }

    
}
- (void)getData {
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSInteger num = [self.bookId integerValue];
    NSNumber *bookId = [NSNumber numberWithInteger:num];
    [bodyDic setObject:bookId forKey:@"book_id"];
    [bodyDic setObject:@1 forKey:@"p"];
    [bodyDic setObject:@10 forKey:@"limit"];
    NSNumber *type = [NSNumber numberWithInteger:self.type];
    [bodyDic setObject:type forKey:@"type"];


    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JBookDetail Handler:^(NSDictionary *jsonDic, NSError * error) {

        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.bookDetailDict = jsonDic[@"data"][@"bookDetail"];
                self.dataDict = jsonDic[@"data"];
                [UserDefaults setObject:self.bookDetailDict forKey:@"BookDetail"];
                [UserDefaults setObject:self.dataDict forKey:@"dataDetail"];
                //                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self initUiWithData];
                
                //发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dataDetail" object:nil];
//                });
            }
        }else{

        }

    }];
}

- (void)addBottomView {
    UILabel *priceLabel = [[UILabel alloc] init];
    _priceLabel = priceLabel;
    priceLabel.text = @"999金豆";
    priceLabel.backgroundColor = [UIColor whiteColor];
    priceLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:priceLabel];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(width/2);
        make.height.mas_equalTo(40);
    }];
    
    priceLabel.text = [NSString stringWithFormat:@"%@金豆",_price];
    
    UIButton *priceButton= [[UIButton alloc] init];
    _priceButton = priceButton;
    [priceButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [priceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    priceButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:priceButton];
    
    [priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.equalTo(_priceLabel.mas_right).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [priceButton addTarget:self action:@selector(clickPriceButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPriceButton{
    //购买作品
    //跳转到订单详情页面
    ZWOrderDetailViewController *orderDetailViewController = [[ZWOrderDetailViewController alloc] init];
    orderDetailViewController.paySuccessBlock = ^{
        //设置为已购买
        self.priceButton.backgroundColor = [UIColor grayColor];
        [self.priceButton setTitle:@"已购买" forState:UIControlStateNormal];
        self.priceButton.userInteractionEnabled = NO;
        
        //重新读取数据
        [self getData];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fresh" object:nil];
    };
    orderDetailViewController.dataDict = self.dataDict;
    orderDetailViewController.bookDict = self.dataDict[@"bookDetail"];
    orderDetailViewController.price = self.price;
    [self.navigationController pushViewController:orderDetailViewController animated:YES]; 
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
        CGFloat bottomCellOffset = _audioDetailHeaderView.height+90;
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
        AudioFloatTableCell *clientCell=[tableView dequeueReusableCellWithIdentifier:@"float"];
        if (clientCell==nil) {
            clientCell=[[[NSBundle mainBundle]loadNibNamed:@"AudioFloatTableCell" owner:self options:nil]lastObject];
        }
        clientCell.clipsToBounds=YES;
        clientCell.selectionStyle=UITableViewCellSelectionStyleNone;
        clientCell.tag=indexPath.row;
        
        clientCell.isFocus = self.bookDetailDict[@"fouseUser"];
        clientCell.dict = self.bookDetailDict[@"userInfo"];
        
        return clientCell;
    }
    AudioFloatContainerCell *contain=[tableView dequeueReusableCellWithIdentifier:@"container"];
    contain=[[AudioFloatContainerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"container"];
    contain.VC=self;
    contain.dataDict = self.dataDict;
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

- (IBAction)clickFocusButton:(id)sender {
    [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
    [self.focusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
@end
