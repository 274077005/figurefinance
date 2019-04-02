//
//  DlgPayWayV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "DlgPayWayV.h"

@implementation DlgPayWayV


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer * weBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weChatBVClick)];
    [self.weChatBV addGestureRecognizer: weBVTGR];
    UITapGestureRecognizer * aLiBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aLiBVClick)];
    [self.aLiBV addGestureRecognizer: aLiBVTGR];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",self.moneyStr];
    self.payWay = @"wePay";
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self close:nil];
}
- (IBAction)payBtnClick:(UIButton *)sender {
    if (self.submitBlock) {
        self.submitBlock(self.payWay);
    }
    [self close:nil];
}
- (void)weChatBVClick
{
    self.payWay = @"wePay";
    self.weStatusImgV.image = IMG_Name(@"lSelect");
    self.aLiStatusImgV.image = IMG_Name(@"lNoSelect");
}
- (void)aLiBVClick
{
    self.payWay = @"aLiPay";
    self.aLiStatusImgV.image = IMG_Name(@"lSelect");
    self.weStatusImgV.image = IMG_Name(@"lNoSelect");
}
@end
