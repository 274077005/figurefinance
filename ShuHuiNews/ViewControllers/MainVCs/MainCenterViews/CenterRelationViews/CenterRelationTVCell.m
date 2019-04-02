 //
//  CenterRelationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterRelationTVCell.h"
#import "EditRelationVC.h"
@implementation CenterRelationTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateWithModel
{
    CenterContactModel * contactModel  = _centerModel.contact;
    self.telLab.text = contactModel.phone;
    self.emailLab.text = contactModel.email;
    self.weChatLab.text = contactModel.wechat;
}

- (IBAction)editBtnCLick:(UIButton *)sender {
    EditRelationVC * editVC = [[EditRelationVC alloc]init];
    editVC.contactModel = _centerModel.contact;
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
}
-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    CALayer *BVLayer = [[CALayer alloc] init];
    BVLayer.position = _shadowBV.layer.position;
    BVLayer.frame = _shadowBV.frame;
    BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    BVLayer.shadowColor = [UIColor grayColor].CGColor;
    
    
    
    BVLayer.shadowOffset = CGSizeMake(2, 2);
    BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    
}
@end
