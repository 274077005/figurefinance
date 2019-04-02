//
//  AboutUsVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLab.text = [NSString stringWithFormat:@"V%@",versionStr];
    _contentLab.text = @"数汇资讯App是致力于构建资源共享，信息共享的平台。";
    // Do any additional setup after loading the view from its nib.
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
