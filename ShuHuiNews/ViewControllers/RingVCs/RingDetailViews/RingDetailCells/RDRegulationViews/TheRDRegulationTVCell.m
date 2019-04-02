//
//  TheRDRegulationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheRDRegulationTVCell.h"

@implementation TheRDRegulationTVCell
{
    NSArray * _statusArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _statusArr = @[@"未知状态",@"监管中",@"书面认证",@"可担保",@"旗舰店",@"超限经营",@"离岸监管",@"疑似套牌"];
    // Initialization code
}
-(void)updateWithModel
{
    [self.coverImgV sd_setImageWithURL:IMG_URL(_arrModel.logo_url)];
    self.nameLab.text = [NSString stringWithFormat:@"%@  %@",_arrModel.agency_name,_arrModel.license_type];
    self.numberLab.text = [NSString stringWithFormat:@"监管号: %@",_arrModel.supervision_number];
    NSInteger status = [_arrModel.status integerValue];
    [_statusBtn setTitle:_statusArr[status] forState:UIControlStateNormal];
    if (status >5) {
        _statusBtn.backgroundColor = RGBCOLOR(235, 29, 34);
    }else{
        _statusBtn.backgroundColor = RGBCOLOR(35, 122, 229);
    }
//    if (status == 0) {
//        _statusBtn.hidden = YES;
//    }else{
//        _statusBtn.hidden = NO;
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
