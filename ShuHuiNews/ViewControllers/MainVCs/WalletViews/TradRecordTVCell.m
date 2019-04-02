//
//  TradRecordTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TradRecordTVCell.h"

@implementation TradRecordTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel
{
    self.titleLab.text = _recordModel.deal_format;
    self.moneyLab.text = _recordModel.deal_money;
    self.timeLab.text = _recordModel.deal_time;
//    self.balanceLab.text = _recordModel.money_source;
}

@end
