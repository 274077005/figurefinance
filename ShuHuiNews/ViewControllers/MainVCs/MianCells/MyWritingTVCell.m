//
//  MyWritingTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/19.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MyWritingTVCell.h"
#import "MainSetVC.h"
#import "BellViewController.h"
#import "MainWorksVC.h"
#import "MainWalletVC.h"
#import "ActivityApplyVC.h"
#import "OrderListVC.h"
#import "MainFlashVC.h"
#import "MyOrderViewController.h"
@implementation MyWritingTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * flashBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flashBVClick)];
    [_flashBV addGestureRecognizer:flashBVTGR];

    
    
    UITapGestureRecognizer * writBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(writBVClick)];
    [_writingBV addGestureRecognizer: writBVTGR];
    UITapGestureRecognizer * bellBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bellBVClick)];
    [_bellBV addGestureRecognizer: bellBVTGR];

    
    UITapGestureRecognizer * walletBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(walletBVClick)];
    [_walletBV addGestureRecognizer: walletBVTGR];
    
    
    UITapGestureRecognizer * activityBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activityBVClick)];
    [_activityBV addGestureRecognizer: activityBVTGR];
    
    
    UITapGestureRecognizer * setBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setBVClick)];
    [_setBV addGestureRecognizer: setBVTGR];
    
    UITapGestureRecognizer * orderBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderBVClick)];
    [_orderBV addGestureRecognizer: orderBVTGR];
    //    [self performSelector:NSSelectorFromString(@"aaa") withObject:cell withObject:cfg];
    // Initialization code
}
-(void)flashBVClick
{
    MainFlashVC * flashVC = [[MainFlashVC alloc]init];
    
    [self.viewContoller.navigationController pushViewController:flashVC animated:YES];
}
-(void)writBVClick
{
    MainWorksVC * workVC = [[MainWorksVC alloc]init];
    [self.viewContoller.navigationController pushViewController:workVC animated:YES];
}
-(void)bellBVClick
{
    BellViewController * bellVC = [[BellViewController alloc]init];
    [self.viewContoller.navigationController pushViewController:bellVC animated:YES];
}
-(void)activityBVClick
{
    ActivityApplyVC * applyVC = [[ActivityApplyVC alloc]init];
    [self.viewContoller.navigationController pushViewController:applyVC animated:YES];
}
-(void)setBVClick
{
    MainSetVC * setVC = [[MainSetVC alloc]init];
    [self.viewContoller.navigationController pushViewController:setVC animated:YES];
}
-(void)walletBVClick
{
//    MainWalletVC * walletVC = [[MainWalletVC alloc]init];
//    [self.viewContoller.navigationController pushViewController:walletVC animated:YES];
    MyOrderViewController *myOrder= [[MyOrderViewController alloc] init];
    [self.viewContoller.navigationController pushViewController:myOrder animated:YES];
}
-(void)orderBVClick
{
    OrderListVC * orderVC = [[OrderListVC alloc]init];
    [self.viewContoller.navigationController pushViewController:orderVC animated:YES];
}
@end
