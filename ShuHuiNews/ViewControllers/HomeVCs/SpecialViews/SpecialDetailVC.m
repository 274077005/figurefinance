//
//  SpecialDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SpecialDetailVC.h"

@interface SpecialDetailVC ()

@end

@implementation SpecialDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSStringFromClass([self.navigationController class]));
    
//    self.navigationController.navigationBar.hidden = YES;
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.hidden = YES;//这是那个线
    backBar.subviews.lastObject.alpha = 0.0;
    

    _recommendV = [[HomeRecommendV alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)withType:1 valueStr:_specialId];
    _recommendV.specailToHere = YES;
    [self.view addSubview:_recommendV];
    // Do any additional setup after loading the view.
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}
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
