//
//  RingNormalTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingNormalTVCell.h"

@implementation RingNormalTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateWithModel
{
    [self.headerImgV sd_setImageWithURL:_listModel.image placeholderImage:IMG_Name(@"headerHold")];
    self.nameLab.text = _listModel.nickname;
    self.tagLab.text = _listModel.attestation_tag;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
