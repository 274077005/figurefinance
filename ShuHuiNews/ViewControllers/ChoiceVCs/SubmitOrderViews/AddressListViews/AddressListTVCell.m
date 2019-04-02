//
//  AddressListTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AddressListTVCell.h"

@implementation AddressListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editBtnClick:(UIButton *)sender {
    EditAddressVC * editVC = [[EditAddressVC alloc]init];
    editVC.addModel = self.addModel;
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
}
-(void)updateWithModel
{
    self.nameLab.text = _addModel.name;
    self.phoneLab.text = _addModel.telephone;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",_addModel.city,_addModel.address];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
