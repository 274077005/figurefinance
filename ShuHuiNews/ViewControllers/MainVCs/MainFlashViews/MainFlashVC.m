//
//  MainFlashVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainFlashVC.h"
#import "AddFlashVC.h"
@interface MainFlashVC ()

@end

@implementation MainFlashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的快讯";
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"新建快讯" style:UIBarButtonItemStyleDone target:self action:@selector(editBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    // Do any additional setup after loading the view.
    
    _flashV = [[HomeFlashV alloc]initWithFrame: CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)withFrom:@"2"];
   
    [self.view addSubview:_flashV];
}

- (void)editBtnClick
{
    AddFlashVC * addVC = [[AddFlashVC alloc]init];
    WeakSelf;
    addVC.submitBlock = ^{
        [weakSelf.flashV loadRefreshData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
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
