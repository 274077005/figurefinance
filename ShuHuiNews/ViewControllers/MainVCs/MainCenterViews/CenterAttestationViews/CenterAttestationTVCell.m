//
//  CenterAttestationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterAttestationTVCell.h"
#import "CenterAttestationVC.h"
@implementation CenterAttestationTVCell
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
- (IBAction)editBtnClick:(UIButton *)sender {
    CenterAttestationVC * attVC = [[CenterAttestationVC alloc]init];
    if (self.centerModel.attestation_card.attestation_card.length > 2) {
        attVC.coverUrl = self.centerModel.attestation_card.attestation_card;
 
    }
    
    [self.viewContoller.navigationController pushViewController:attVC animated:YES];
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
    if (self.centerModel.attestation_card.attestation_card.length > 2) {
        [self.coverImgV sd_setImageWithURL:IMG_URL(self.centerModel.attestation_card.attestation_card)];
    }else{
        self.coverImgV.image = IMG_Name(@"attestationHold");
    }
}
@end
