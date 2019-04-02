//
//  RDGradeTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDGradeTVCell.h"

@implementation RDGradeTVCell{
    CALayer * _BVLayer;
    NSArray * _labelArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    _labelArr = @[_firstLab,_secondLab,_thridLab,_fourthLab];
    
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
    self.gradeLab.text = _deModel.overall;
    for (NSInteger i = 0; i < _deModel.gradeArr.count; i++) {
        DetailArrModel * arrModel = _deModel.gradeArr[i];
        UILabel * label = _labelArr[i];
        label.text = [NSString stringWithFormat:@"%@  %@",arrModel.company_name,arrModel.score];
        label.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
