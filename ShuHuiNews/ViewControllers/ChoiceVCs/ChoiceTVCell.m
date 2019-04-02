//
//  ChoiceTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChoiceTVCell.h"

@implementation ChoiceTVCell

- (void)awakeFromNib {
    [super awakeFromNib];

//
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CALayer *layer = [[CALayer alloc] init];
    layer.position = _coverImgV.layer.position;
    
    layer.bounds = _coverImgV.bounds;
    layer.cornerRadius = _coverImgV.layer.cornerRadius;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.4;
    [self.contentView.layer addSublayer:layer];
    [self.contentView bringSubviewToFront:_coverImgV];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
