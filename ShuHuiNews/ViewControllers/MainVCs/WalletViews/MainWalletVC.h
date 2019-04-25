//
//  MainWalletVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplePay.h"
//我的订购 界面
@interface MainWalletVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *chargeLab;

@end
