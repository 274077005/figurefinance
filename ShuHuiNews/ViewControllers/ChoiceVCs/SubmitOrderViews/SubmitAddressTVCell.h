//
//  SubmitAddressTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitOrderModel.h"
@interface SubmitAddressTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;

@property(nonatomic,strong)SAddressModel * adModel;
-(void)updateWithModel;
@end
