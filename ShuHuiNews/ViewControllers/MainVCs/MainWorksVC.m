//
//  MainWorksVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainWorksVC.h"

@interface MainWorksVC ()

@end

@implementation MainWorksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的文章";
    
    _recommendV = [[HomeRecommendV alloc]initWithFrame: CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)withType:3 valueStr:@""];

    _recommendV.workToHere = YES;
    [self.view addSubview:_recommendV];
    // Do any additional setup after loading the view.
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
