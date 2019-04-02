//
//  ClassWebViewController.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/8/23.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "ClassViewController.h"
#import "GYURLConnection.h"
#import "FHVideoView.h"
#import "PlayerViewController.h"
#import "AppDelegate.h"

@interface ClassViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    //网页视图
    UIWebView * _webView;
    
    NSString * _shareTitle;
    
    NSString * _shareContent;
    UIView * btnView;
    UIView * _linkView;
    NSInteger  _flag;
    UIScrollView * _ScrollView;
}
@end


@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课堂";
    [self createScrollView];
    
  
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    AppDelegate *  delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
}

- (void)createScrollView{

    
    
    
    FHVideoView* v = [[[NSBundle mainBundle] loadNibNamed:@"FHVideoView" owner:self options:nil] firstObject];
    v.frame = CGRectMake(0, TopHeight,SCREEN_WIDTH,SCREEN_HEIGHT - TopHeight - TabBarHeight);
    [v setting];
    __weak typeof(self) weakSelf = self;
    v.block = ^(NSString * sid,NSURL * url,NSString* title){
        NSLog(@"download video enter!");
        
        PlayerViewController *playerViewController = [[PlayerViewController alloc] init];
        playerViewController.index = sid;
        playerViewController.url = url;
        playerViewController.titleName = title;
        [weakSelf.navigationController pushViewController:playerViewController animated:YES];
        
    };
    [self.view addSubview:v];

  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
