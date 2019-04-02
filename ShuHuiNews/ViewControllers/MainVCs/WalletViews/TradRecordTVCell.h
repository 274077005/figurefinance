//
//  TradRecordTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradRecordModel.h"
@interface TradRecordTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property(nonatomic,strong)TradRecordModel * recordModel;

-(void)updateWithModel;
@end
