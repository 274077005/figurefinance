//
//  SubmitAddressTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SubmitAddressTVCell.h"

@implementation SubmitAddressTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel
{
    self.nameLab.text = [NSString stringWithFormat:@"收货人: %@",_adModel.name];
    self.phoneLab.text = _adModel.telephone;
    self.adressLab.text = [NSString stringWithFormat:@"收货地址:%@%@",_adModel.city,_adModel.address];
}
@end
