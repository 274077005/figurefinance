//
//  LaunchAdvertVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/28.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "LaunchAdvertVC.h"
#import "RootTabbarVC.h"
@interface LaunchAdvertVC ()
{
    NSTimer * _advertTimer;
    NSInteger _jumpNum;
}

@end

@implementation LaunchAdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f",StatusBarHeight);
    
    NSLog(@"%@",NSStringFromCGSize([[UIScreen mainScreen] currentMode].size));
    
    
    if (!iphone6) {
        
        self.topHeight.constant = 140;
    }
    if (iphoneX) {
        self.topHeight.constant = 44 + 140;
        self.btnTop.constant = 30;
    }else{
        self.btnTop.constant = 15;
    }
    
    [self getAdvertData];
    [self createAdvertTimer];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_advertTimer invalidate];
    _advertTimer = nil;
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
- (void)createAdvertTimer
{
    _jumpNum = 3;
    _jumpBtn.titleLabel.textColor = [UIColor whiteColor];
    //可以解决圆角问题
    _jumpBtn.layer.cornerRadius = 15;
    _jumpBtn.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:0.5];
    _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _advertTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeJumpBtnTitle) userInfo:nil repeats:YES];
    //创建后默认开启，需要先关闭定时器
    [_advertTimer setFireDate:[NSDate distantFuture]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//跳过按钮点击
-(void)jumpBtnClick
{
    NSLog(@"跳过按钮点击");
    RootTabbarVC * tabVC = [[RootTabbarVC alloc]init];
    self.view.window.rootViewController = tabVC;
}
//获取广告的数据，根据数据判断是否展示广告
-(void)getAdvertData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [GYPostData GetAdvertInfoWithDic:bodyDic UrlPath:JGetLaunchAdvert Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.adModel = [AdvertModel mj_objectWithKeyValues:jsonDic[@"data"]];
                if ([self.adModel.is_show isEqualToString:@"1"]) {
                    [self setUpAdvertViews];
                }else{
                    [self jumpBtnClick];
                }
            }else{
                //如果没广告
                [self jumpBtnClick];
            }
        }else{
            //如果获取超时，则直接跳主页
            [self jumpBtnClick];
        }
    }];
}
//拉取到广告后 设置显示
-(void)setUpAdvertViews
{
    [self.view bringSubviewToFront:_advertBV];
    [_advertImgV sd_setImageWithURL:_adModel.pic_url];
    [_advertTimer setFireDate:[NSDate distantPast]];
    UITapGestureRecognizer *advertTGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advertImgVClick)];
    _advertImgV.userInteractionEnabled = YES;
    [_advertImgV addGestureRecognizer:advertTGR];
}
-(void)advertImgVClick
{
    [UserInfo share].advertUrl = _adModel.href_url;
    [UserInfo share].advertClick = YES;
    [self jumpBtnClick];
}
//修改跳过的按钮的title
- (void)changeJumpBtnTitle
{
    if (0 == _jumpNum) {
        [self jumpBtnClick];
    }
    
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@" %ld 跳过 ",_jumpNum]];
    
    //    [timeStr addAttribute:NSForegroundColorAttributeName value:GrayColor range:NSMakeRange(0,4)];
    [timeStr addAttribute:NSFontAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
    [timeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 2)];
    _jumpBtn.titleLabel.attributedText = timeStr;
    [_jumpBtn setAttributedTitle:timeStr forState:UIControlStateNormal];
    _jumpNum--;
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
