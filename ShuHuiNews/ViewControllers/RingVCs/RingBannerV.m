//
//  RingBannerV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingBannerV.h"
#import "RingWriteVC.h"
#import "RingQAVC.h"
#import "StockViewController.h"
#import "LoveStockListVC.h"
#import "ChainMarketVC.h"
@implementation RingBannerV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)writeBtnClick:(UIButton *)sender {
    RingWriteVC* writeVC = [[RingWriteVC alloc]init];
    writeVC.writeType = @"1";
    writeVC.industryId = self.industryId;
    [self.viewContoller.navigationController pushViewController:writeVC animated:YES];
    
}
- (IBAction)flashBtnClick:(UIButton *)sender {

    //如果还不知道当前页面的Id  则不继续执行
    if (!_industryId) {
        return;
    }
    if ([_industryId isEqualToString:@"98"]) {
        ChainMarketVC * marketVC = [[ChainMarketVC alloc]init];
        [self.viewContoller.navigationController pushViewController:marketVC animated:YES];
    }else{
        LoveStockListVC * loveVC = [[LoveStockListVC alloc]init];
        [self.viewContoller.navigationController pushViewController:loveVC animated:YES];
    }
    
}
- (IBAction)QABtnClick:(UIButton *)sender {
    
    RingQAVC * qaVC = [[RingQAVC alloc]init];
    
    [self.viewContoller.navigationController pushViewController:qaVC animated:YES];
    
    
}




@end
