//
//  HomeFlashTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RecommendFlashTVCell.h"

@implementation RecommendFlashTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithModel
{
    _contentLab.text = _newsModel.content;
    [_headImgV sd_setImageWithURL:_newsModel.head_portrait placeholderImage:IMG_Name(@"headerHold")];
    _titleLab.text = [NSString stringWithFormat:@"%@ %@",_newsModel.datetime,_newsModel.type_name];
    if (_newsModel.top_ok == 1) {
        _topLab.hidden = NO;
    }else{
        _topLab.hidden = YES;
    }
}

@end
