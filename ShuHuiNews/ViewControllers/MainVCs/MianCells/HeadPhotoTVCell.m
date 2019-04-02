//
//  HeadPhotoTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HeadPhotoTVCell.h"
#import "LoginViewController.h"
#import "ScanQRCodeVC.h"
#import "MainCenterVC.h"
#import "FansViewController.h"
#import "LikeViewController.h"
@implementation HeadPhotoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView * ballView = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    ballView.backgroundColor = [UIColor whiteColor];
    [self addSubview:ballView];
    UITapGestureRecognizer * likeBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeBVClick)];
    [_likeBV addGestureRecognizer: likeBVTGR];
    UITapGestureRecognizer * fansBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fansBVClick)];
    [_fansBV addGestureRecognizer: fansBVTGR];
    UITapGestureRecognizer * collectBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectBVClick)];
    [_collectBV addGestureRecognizer: collectBVTGR];
    _editLab.userInteractionEnabled = YES;
    UITapGestureRecognizer * editLabTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBtnClick:)];
    [_editLab addGestureRecognizer: editLabTGR];
    _nameLab.userInteractionEnabled = YES;
    UITapGestureRecognizer * nameTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBtnClick:)];
    [_nameLab addGestureRecognizer: nameTGR];
    // Initialization code
}
- (IBAction)mainGoQRBtnClick:(UIButton *)sender {
    ScanQRCodeVC * QRVC = [[ScanQRCodeVC alloc]init];
    [self.viewContoller.navigationController pushViewController:QRVC animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)likeBVClick
{
    LikeViewController * fansVC = [[LikeViewController alloc]init];
    [self.viewContoller.navigationController pushViewController:fansVC animated:YES];
}
-(void)fansBVClick
{
    FansViewController * fansVC = [[FansViewController alloc]init];
    [self.viewContoller.navigationController pushViewController:fansVC animated:YES];
}
- (void)collectBVClick
{
    MainCollectVC * collectVC = [[MainCollectVC alloc]init];
    [self.viewContoller.navigationController pushViewController:collectVC animated:YES];
}
- (void)updateWithModel
{
    self.nameLab.text = _mainModel.nickname;
    [_photoBtn sd_setImageWithURL:_mainModel.image forState:UIControlStateNormal];
    self.likeLab.text = _mainModel.attent_num;
    self.fansLab.text = _mainModel.comment_num;
    self.collectLab.text = _mainModel.collect_num;
}
- (IBAction)photoBtnClick:(UIButton *)sender {
    
    MainCenterVC * editVC = [[MainCenterVC alloc]init];
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
    
    
}

@end
