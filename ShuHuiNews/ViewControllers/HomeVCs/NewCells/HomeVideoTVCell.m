//
//  HomeNormalTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeVideoTVCell.h"

@implementation HomeVideoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateWithModel
{
    _contentLab.text = _newsModel.title;
    [_headImgV sd_setImageWithURL:_newsModel.head_portrait placeholderImage:IMG_Name(@"headerHold")];
    [_bigImgV sd_setImageWithURL:_newsModel.imgurl];
    _titleLab.text = [NSString stringWithFormat:@"%@ %@",_newsModel.datetime,_newsModel.type_name];
    if (_newsModel.top_ok == 1) {
        _topLab.hidden = NO;
    }else{
        _topLab.hidden = YES;
    }
    self.durationLab.text = _newsModel.duration;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
