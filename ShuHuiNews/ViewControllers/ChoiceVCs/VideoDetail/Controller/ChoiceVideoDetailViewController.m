//
//  ChoiceVideoDetailViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/19.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "ChoiceVideoDetailViewController.h"
#import "XHPlayer.h"
#import "GYPostData+video.h"
#import "AppDelegate.h"
@interface ChoiceVideoDetailViewController ()<XHPlayerDelegate>
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) CGRect playerFrame;
@property (nonatomic, assign) CGRect cloudPlayerFrame;
@property (nonatomic,assign) CGFloat teacherLabHeight;
@property (nonatomic, strong) XHPlayer * player;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic,strong) UIButton *firstBackBtn;
@end

@implementation ChoiceVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setHidden:YES];
    [self createUI];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_player) {
        [_player close];
        [_player removeNotification];
        _player = nil;
    }
}
- (void)createUI
{
    _playerView = [[UIView alloc] init];
    _playerView.backgroundColor = [UIColor blackColor];
    CGSize size = self.view.bounds.size;
    CGRect frame = CGRectMake(0,0,size.width,size.height);
    self.view.frame = frame;
    CGFloat width = size.width;
    _height = width * 9.0f / 16.0f;
    _playerView.frame = CGRectMake(0, 0, size.width, _height);
    _playerFrame = _playerView.frame;
    self.player.mediaPath = [NSString stringWithFormat:@"%@",self.url];
    _player.origianlFrame = _playerView.frame;
    _player.delegate = self;
    if (iphoneX) {
        _player.frame = CGRectMake(0, 20, size.width, _height - 20);
    }else{
        _player.frame = _playerView.frame;
    }
    [_playerView addSubview:_player];
    [_playerView bringSubviewToFront:_player];
    self.player.firstSuperView = _playerView;
    self.player.title = @"safa";
    [self.view addSubview:_playerView];
    
    _firstBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iphoneX) {
        _firstBackBtn.frame = CGRectMake(5, 25, 44, 44);
    }else{
        _firstBackBtn.frame = CGRectMake(5, 5, 44, 44);
    }
    
    
    [_firstBackBtn setImage:[UIImage imageNamed:@"player_back.png"] forState:UIControlStateNormal];
    
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
#pragma mark --layzing

- (XHPlayer *)player{
    if (!_player) {
        _player = [[XHPlayer alloc] init];
    }
    return _player;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
