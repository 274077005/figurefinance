//
//  TheRegulationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheRegulationTVCell.h"

@implementation TheRegulationTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateWithModel
{
    [self.coverImgV sd_setImageWithURL:IMG_URL(self.regulationModel.logo_url)];
    self.timeLab.text = [NSString stringWithFormat:@"发证时间:%@",self.regulationModel.start_time];
    self.nameLab.text = [NSString stringWithFormat:@"%@ %@  监管号:%@",self.regulationModel.agency_name,self.regulationModel.license_type,self.regulationModel.supervision_number];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
