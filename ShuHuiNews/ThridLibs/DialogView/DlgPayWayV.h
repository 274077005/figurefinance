//
//  DlgPayWayV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "DialogView.h"

@interface DlgPayWayV : DialogBase
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIView *weChatBV;
@property (weak, nonatomic) IBOutlet UIView *aLiBV;
@property (weak, nonatomic) IBOutlet UIImageView *weStatusImgV;
@property (weak, nonatomic) IBOutlet UIImageView *aLiStatusImgV;


@property(copy,nonatomic)NSString * moneyStr;

@property(copy,nonatomic)NSString * payWay;

@property(nonatomic,copy)void(^submitBlock)(NSString * payStr);
@end
