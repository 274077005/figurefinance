//
//  RootTabbarVC.m
//  Qianyuandai
//
//  Created by 耿一 on 2017/10/18.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import "RootTabbarVC.h"
#import "SystemNVC.h"
#import "HomeViewController.h"
#import "MainViewController.h"
#import "ChoiceVC.h"
#import "RingRootController.h"
#import "SocketTestVC.h"
#import "CalendarVC.h"
@interface RootTabbarVC ()

@end

@implementation RootTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tabBar颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self setUpAllChildViewController];
    
    //给Tabbar加阴影
    self.tabBar.layer.cornerRadius = 5;
    self.tabBar.layer.shadowColor = RGBCOLOR(137, 144, 171).CGColor;//shadowColor阴影颜色
    self.tabBar.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移
    self.tabBar.layer.shadowOpacity = 1.0;
    self.tabBar.layer.shadowRadius = 3;
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}
- (void)setUpAllChildViewController
{
    HomeViewController * homeVC = [[HomeViewController alloc]init];
//    SocketTestVC * homeVC = [[SocketTestVC alloc]init];
//    CalendarVC * homeVC = [[CalendarVC alloc]init];
    
    [self setUpOneChildViewController:homeVC image:[UIImage imageNamed:@"homeTab"] selectImage:[UIImage imageNamed:@"homeTabS"] title:@"资讯"];
    

    RingRootController * ringVC = [[RingRootController  alloc]init];
    [self setUpOneChildViewController:ringVC image:[UIImage imageNamed:@"ringTab"] selectImage:[UIImage imageNamed:@"ringTabS"] title:@"微圈"];
    
    ChoiceVC * choiceVC = [[ChoiceVC alloc]init];
    [self setUpOneChildViewController:choiceVC image:[UIImage imageNamed:@"choiceTab"] selectImage:[UIImage imageNamed:@"choiceTabS"] title:@"精选"];
//
    MainViewController * mainVC = [[MainViewController alloc]init];
    [self setUpOneChildViewController:mainVC image:[UIImage imageNamed:@"mainTab"] selectImage:[UIImage imageNamed:@"mainTabS"] title:@"我的"];
    
    
    //设置tabBar颜色
    self.tabBar.barTintColor = RGBCOLOR(250, 250, 250);
    //设置TabBarItem被选中的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(208, 208, 208)} forState:UIControlStateNormal];
    [[UITabBarItem appearance]  setTitleTextAttributes:@{NSForegroundColorAttributeName:WD_BLUE} forState:UIControlStateSelected];
}

/**
 *  添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{

    
    SystemNVC * navC = [[SystemNVC alloc]initWithRootViewController:viewController];
    navC.title = title;
    navC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    //    viewController.navigationItem.title = title;
    [self addChildViewController:navC];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    
    
    NSInteger i = [self.viewControllers indexOfObject:viewController];

    if(i == 3){
        if([UserInfo share].isLogin){
            return YES;
        }else{
            LoginViewController * loginVC = [[LoginViewController alloc]init];
            SystemNVC * navC = [[SystemNVC alloc]initWithRootViewController:loginVC];
            [self.selectedViewController presentViewController:navC animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
