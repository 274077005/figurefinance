//
//  RDIntroduceTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDIntroduceTVCell.h"

@implementation RDIntroduceTVCell
{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    // Initialization code
}
-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    self.contentView.layer.masksToBounds = YES;
    _BVLayer.position = _shadowBV.layer.position;
    _BVLayer.frame = _shadowBV.frame;
    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
    _BVLayer.shadowOffset = CGSizeMake(2, 2);
    _BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    
}
- (void)updateWithModel
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_deModel.desc];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];

    
    [paragraphStyle setLineSpacing:5.0];
     [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    self.contentLab.attributedText = attributedString;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
