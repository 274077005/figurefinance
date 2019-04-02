//
//  PlayerViewController.m
//  TestYKMediaPlayer
//
//  Created by weixinghua on 13-6-25.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//

#import "PlayerViewController.h"
#import "XHPlayer.h"
#import "GYPostData+video.h"
#import "AppDelegate.h"
#import "teacherInfoTableViewCell.h"
#import "moreVideoTableViewCell.h"
#import "GYURLConnection.h"
#define MARGIN (DEVICE_TYPE_IPAD ? 15 : 10)
#define BACK_WIDTH (DEVICE_TYPE_IPAD ? 30 : 20)
#define TEXTVIEW_FONT (DEVICE_TYPE_IPAD ? 15 : 12)
#define TEXTSCREEN_WIDTH (DEVICE_TYPE_IPAD ? 400 : 250)
#define TEXTSCREEN_HEIGHT (DEVICE_TYPE_IPAD ? 45 : 30)
#define TOPSCREEN_HEIGHT_SMALL (DEVICE_TYPE_IPAD ? 54 : 44)
#define TOPSCREEN_HEIGHT_FULL (DEVICE_TYPE_IPAD ? 88 : 50)
#define STATUS_HEIGHT (DEVICE_TYPE_IPAD ? 25 : 20)
#define XHVideoName(file) [@"PlayerTool.bundle" stringByAppendingPathComponent:file]
@interface PlayerViewController () <UITableViewDelegate,UITableViewDataSource,XHPlayerDelegate>
{
    UITableView * _tableView;
    UIButton * _firstBackBtn;
    
}

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) CGRect playerFrame;
@property (nonatomic, assign) CGRect cloudPlayerFrame;
@property (nonatomic,assign) CGFloat teacherLabHeight;
@property (nonatomic, strong) XHPlayer * player;

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic, assign) CGFloat height;
@end

@implementation PlayerViewController


#pragma mark - init & dealloc


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate *  delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 1;
    [self getData];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
    _playerView = [[UIView alloc] init];
    _playerView.backgroundColor = [UIColor blackColor];
    
    CGSize size = self.view.bounds.size;
    CGRect frame = CGRectMake(0,0,size.width,size.height);
    self.view.frame = frame;
    
    CGFloat width = 0.f;
    if (DEVICE_TYPE_IPAD) {
        width = 681.f;
    } else {
        width = size.width;
    }
    _height = width * 9.0f / 16.0f;
    _playerView.frame = CGRectMake(0, 0, size.width, _height);
    
    
    _playerFrame = _playerView.frame;
    
    self.player.mediaPath =[NSString stringWithFormat:@"%@",self.url];
    self.player.mediaPath = @"http://db.figurefinance.com/29d1ac21021947daaec8d029b27caaca/cc24098ca801448b945b595031dcdee4-5287d2089db37e62345123a1be272f8b.mp4";
    NSLog(@"%@",self.player.mediaPath);
    _player.origianlFrame = _playerView.frame;
    _player.delegate =self;
    if (iphoneX) {
        _player.frame = CGRectMake(0, 20, size.width, _height - 20);
    }else{
        _player.frame = _playerView.frame;
    }
    
    [_playerView addSubview:_player];
    [_playerView bringSubviewToFront:_player];
    
    self.player.firstSuperView = _playerView;
    self.player.title =self.titleName;
    
    [self.view addSubview:_playerView];
    
    _teacherLabHeight = 70;
    [self createTableView];
    
    
    
    _firstBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iphoneX) {
        _firstBackBtn.frame = CGRectMake(5, 25, 44, 44);
    }else{
        _firstBackBtn.frame = CGRectMake(5, 5, 44, 44);
    }
    
    
    [_firstBackBtn setImage:[UIImage imageNamed:XHVideoName(@"player_back")] forState:UIControlStateNormal];
    
    [_firstBackBtn.layer setCornerRadius:15];
    [_firstBackBtn.layer setMasksToBounds:YES];
    [_firstBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstBackBtn];
    
    
    
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    //    UIViewController * vc = self.navigationController.viewControllers[1];
    //    [self.navigationController popToViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}
#pragma mark --获取数据
- (void)getData{
    [SVProgressHUD show];
    [GYPostData getVideoDetailsWith:@{@"id":self.index} handler:^(NSArray*arr, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [self.dataSource addObjectsFromArray:arr];
            
            
            [_tableView reloadData];
        }
    }];
    
}

#pragma mark -- tableView

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _height,SCREEN_WIDTH,SCREEN_HEIGHT-_height)];
    
    _tableView.delegate =self;
    _tableView.dataSource = self;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"teacherInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"teacherInfoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"moreVideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"moreVideoTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        teacherInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"teacherInfoTableViewCell"];
        __weak typeof(self) weakSelf =self;
        __weak typeof (_tableView) weakTable = _tableView;
        cell.play = ^(CGFloat h){
            weakSelf.teacherLabHeight =h;
            NSIndexPath * indexp = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakTable reloadRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        VideoModel * v = self.dataSource[0];
        [cell updateWith:v];
        cell.height = _teacherLabHeight;
        cell.lookAllBtn.selected = _teacherLabHeight == 70 ? NO:YES;
        return cell;
    }else{
        
        moreVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moreVideoTableViewCell"];
        VideoModel * m = self.dataSource[indexPath.row];
        [cell updateWith:m];
        return cell;
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 251.5+_teacherLabHeight;
    }else{
        
        return 105;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
        
        
        VideoModel * m = self.dataSource[indexPath.row];
        
        PlayerViewController * vc = [[PlayerViewController alloc] init];
        
        vc.url = m.video_url;
        vc.titleName = m.title;
        vc.index = m.nameId;
        //统计播放次数
        [GYPostData postVideoPalyWith:@{@"id":m.nameId}];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark --layzing

- (XHPlayer *)player{
    if (!_player) {
        _player = [[XHPlayer alloc] init];
    }
    return _player;
}

-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
    
}
#pragma mark --XHPlayerDelegate
- (void)playerPlaybackDidOver:(XHPlayer *)player{
    
    [self.navigationController popViewControllerAnimated:YES];
    //    UIViewController * vc = self.navigationController.viewControllers[1];
    //    [self.navigationController popToViewController:vc animated:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_player) {
        [_player close];
        [_player removeNotification];
        _player = nil;
    }
    _tableView = nil;
    
}

-(void)dealloc{
    
    
}

@end

