//
//  SpecialDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingWriteVC.h"

@interface RingWriteVC ()

@end

@implementation RingWriteVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([_writeType isEqualToString:@"1"]) {
        self.navigationItem.title = @"文章列表";
    }else{
        self.navigationItem.title = @"快讯列表";
    }
    
    
    NSString * ringValueStr = [NSString stringWithFormat:@"%@|%@",_writeType,self.industryId];
    _recommendV = [[HomeRecommendV alloc]initWithFrame: CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)withType:5 valueStr:ringValueStr];
    _recommendV.ringToHere = YES;
//    _recommendV.ringTypeId = _writeType;
//    _recommendV.industryId = self.industryId;
    [self.view addSubview:_recommendV];
    
    // Do any additional setup after loading the view.
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
