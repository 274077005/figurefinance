//
//  MainadviceVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/19.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainSetVC.h"
#import "AboutUsVC.h"
@interface MainSetVC ()

@end

@implementation MainSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topHeight.constant = TopHeight + 5;
    self.navigationItem.title = @"设置";
    [self getAppSize];
    [self createTGR];
    // Do any additional adviceup after loading the view from its nib.
}

- (void)createTGR
{
    UITapGestureRecognizer * cleanBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cleanBVClick)];
    [_cleanBV addGestureRecognizer: cleanBVTGR];
    UITapGestureRecognizer * aboutBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutBVClick)];
    [_aboutBV addGestureRecognizer: aboutBVTGR];
    UITapGestureRecognizer * adviceBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adviceBVClick)];
    [_adviceBV addGestureRecognizer: adviceBVTGR];
    UITapGestureRecognizer * quitBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quitBVClick)];
    [_quitBV addGestureRecognizer: quitBVTGR];
}
-(void)cleanBVClick
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{

        [SVProgressHUD showWithString:@"清除完毕~"];
        [self getAppSize];
    }];
}
-(void)aboutBVClick
{
    AboutUsVC * usVC = [[AboutUsVC alloc]init];
    [self.navigationController pushViewController:usVC animated:YES];
}
-(void)adviceBVClick
{
    BaseWebVC * webVC = [[BaseWebVC alloc]init];
    
    webVC.urlStr = [NSString stringWithFormat:@"%@zixun/opinion_feeckback",Main_Url];
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)quitBVClick
{
    [UserInfo share].isLogin = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
    
    
    SystemNVC *nvc = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0];
    nvc.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)getAppSize
{
    NSInteger size = [[SDWebImageManager sharedManager].imageCache getSize];
    NSString* sizeStr = @"";
    if (size < 1024) {
        sizeStr = [NSString stringWithFormat:@"%ldB", (long)size];
    } else if (size < (1024*1024)) {
        sizeStr = [NSString stringWithFormat:@"%0.1fKB", (double)size/(1024)];
    } else {
        sizeStr = [NSString stringWithFormat:@"%0.1fMB", (double)size/(1024*1024)];
    }
    self.cleanLab.text = sizeStr;
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
