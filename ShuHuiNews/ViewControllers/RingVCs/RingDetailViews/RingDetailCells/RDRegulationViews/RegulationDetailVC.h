//
//  RegulationDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "CheckCertificateVC.h"
@interface RegulationDetailVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgV;
@property (weak, nonatomic) IBOutlet UILabel *logoLab;
@property (weak, nonatomic) IBOutlet UILabel *licenseTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *institutionNameLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *agencyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UILabel *urlLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *cerLab;
@property (weak, nonatomic) IBOutlet UIButton *cerBtn;


@property(nonatomic,strong)DetailArrModel * arrModel;

@end
