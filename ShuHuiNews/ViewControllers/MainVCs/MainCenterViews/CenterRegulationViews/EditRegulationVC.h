//
//  EditRegulationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
#import "ChooseAgencyV.h"
#import "CheckCertificateVC.h"
@interface EditRegulationVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *addBV;

@property (weak, nonatomic) IBOutlet UIView *deleteBV;
@property (nonatomic,assign)BOOL isEdit;
@property (weak, nonatomic) IBOutlet UIView *beginTimeBV;
@property (weak, nonatomic) IBOutlet UIView *endTimeBV;
@property (weak, nonatomic) IBOutlet UIImageView *agencyImgV;
@property (weak, nonatomic) IBOutlet UITextField *agencyNameLab;//监管机构
@property (weak, nonatomic) IBOutlet UIButton *changeAgencyBtn;

@property (weak, nonatomic) IBOutlet UIView *agencyBV;
@property (weak, nonatomic) IBOutlet UITextField *typeTF; //牌照类型
@property (weak, nonatomic) IBOutlet UITextField *numberTF; //监管号
@property (weak, nonatomic) IBOutlet UITextField *beginTF;
@property (weak, nonatomic) IBOutlet UITextField *endTF;
@property (weak, nonatomic) IBOutlet UITextField *institutionTF; //挂牌机构
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *urlTF; //网址
@property (weak, nonatomic) IBOutlet UITextField *addressTF; //地址
@property (weak, nonatomic) IBOutlet UITextField *certificateTF; //证书
@property (weak, nonatomic) IBOutlet UIView *certificateBV;
@property (weak, nonatomic) IBOutlet UIView *noCerBV;
@property (weak, nonatomic) IBOutlet UIView *beCerBV;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn; //上传证书按钮
@property (weak, nonatomic) IBOutlet UILabel *cerAgencyLab;



@property(nonatomic,copy)NSString * imgStr; //记录证书的字符串

@property(nonatomic,strong)MainCenterModel * centerModel;

@property(nonatomic,strong)CenterRegulationModel * reModel;

@property(nonatomic,strong)ChooseAgencyV * cAgencyV;


@property(nonatomic,strong)UIImage * cerImg;

@end
