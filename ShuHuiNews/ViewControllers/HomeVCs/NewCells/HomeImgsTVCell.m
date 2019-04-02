//
//  HomeImgsTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeImgsTVCell.h"

@implementation HomeImgsTVCell
{
    NSArray * _imgVArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgVArr = @[_image1,_image2,_image3];
    // Initialization code
}
- (void)updateWithModel
{
    _contentLab.text = _newsModel.title;
//    _contentLab.text = @"浔阳江头夜送客，枫叶荻花秋瑟瑟。主人下马客在船，举酒欲饮无管弦。醉不成欢惨将别，别时茫茫江浸月。";
    [_headImgV sd_setImageWithURL:_newsModel.head_portrait placeholderImage:IMG_Name(@"headerHold")];
    _titleLab.text = [NSString stringWithFormat:@"%@ %@",_newsModel.datetime,_newsModel.type_name];
    if (_newsModel.top_ok == 1) {
        _topLab.hidden = NO;
    }else{
        _topLab.hidden = YES;
    }
    
    for (NSInteger i = 0 ;i < _imgVArr.count;i++ ) {
        UIImageView *imgV = _imgVArr[i];
        if (i < _newsModel.images.count) {
            imgV.hidden = NO;
            ImgListModel * imgModel = _newsModel.images[i];
            [imgV sd_setImageWithURL:imgModel.imgurl];
        }else{
            imgV.hidden = YES;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
