//
//  CenterCompanyTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterPersonalBasicTVCell.h"
#import "EditPersonalBasicsVC.h"
@implementation CenterPersonalBasicTVCell
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
    EditPersonalBasicsVC * editVC = [[EditPersonalBasicsVC alloc]init];
    editVC.atModel = _centerModel.attestation;
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
    
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
    CenterAttestationModel * atModel  = _centerModel.attestation;
    self.nameLab.text = atModel.attestation_name;
    self.jobLab.text = atModel.attestation_job;
    self.companyNameLab.text = atModel.attestation_company;
    if (atModel.attestation_card.length > 1) {
        [self.cardImgV sd_setImageWithURL:IMG_URL(atModel.attestation_card)];
    }


}


@end
