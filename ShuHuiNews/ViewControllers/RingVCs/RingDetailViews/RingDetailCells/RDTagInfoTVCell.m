//
//  CenterTagInfoTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDTagInfoTVCell.h"
#import "CenterTagVC.h"
@implementation RDTagInfoTVCell
{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
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
-(void)updateWithModel
{
    [self setUpScrollV];
}
-(void)setUpScrollV
{
    
    [self.scrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray * tagArr = [self.attModel.attestation_tag componentsSeparatedByString:@"|"];

    CGFloat scrollWidth = 10;
    CGFloat space = 10;
    for ( NSInteger i = 0; i < tagArr.count; i++) {
        NSString * tagStr = tagArr[i];
        CGFloat width = [GYToolKit LabelWidthWithSize:12 height:24 str:tagStr] + 20;
        UILabel * tagLab = [[UILabel alloc]initWithFrame:CGRectMake(scrollWidth, 13, width, 24)];
        tagLab.font = [UIFont systemFontOfSize:12];
        tagLab.textColor = RGBCOLOR(31, 31, 31);
        tagLab.layer.masksToBounds = YES;
        tagLab.layer.cornerRadius = 12;
        tagLab.backgroundColor = RGBCOLOR(246, 246, 246);
        tagLab.text = tagStr;
        tagLab.textAlignment = NSTextAlignmentCenter;
        [_scrollV addSubview:tagLab];
        scrollWidth = scrollWidth + width + space;
        
    }
    [_scrollV setContentSize:CGSizeMake(scrollWidth, 50)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
