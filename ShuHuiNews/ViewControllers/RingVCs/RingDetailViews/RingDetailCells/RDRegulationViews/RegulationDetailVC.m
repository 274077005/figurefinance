//
//  RegulationDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RegulationDetailVC.h"

@interface RegulationDetailVC ()
{
    NSArray * _labArr;
    NSArray * _statusArr;
}

@end

@implementation RegulationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topHeight.constant = TopHeight;
    _labArr = @[_licenseTypeLab,_statusLab,_institutionNameLab,_numberLab,_agencyNameLab,_beginTimeLab,_endTimeLab,_phoneLab,_emailLab,_urlLab,_addressLab,_cerLab];
    _statusArr = @[@"未知",@"监管中",@"书面认证",@"可担保",@"旗舰店",@"超限经营",@"离岸监管",@"疑似套牌"];
    [self setUpContentView];
    // Do any additional setup after loading the view from its nib.
}
-(void)setUpContentView
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@·监管信息",_arrModel.institution];
    [self.logoImgV sd_setImageWithURL:IMG_URL(_arrModel.logo_url)];
    self.logoLab.text = [NSString stringWithFormat:@"%@%@",_arrModel.agency_name,_arrModel.license_type];
    self.licenseTypeLab.text = _arrModel.license_type;
    NSInteger status = [_arrModel.status integerValue];
    self.statusLab.text = _statusArr[status];
    self.agencyNameLab.text = _arrModel.agency_name;
    self.numberLab.text = _arrModel.supervision_number;
    self.institutionNameLab.text = _arrModel.institution;
    self.beginTimeLab.text = _arrModel.start_time;
    self.endTimeLab.text = _arrModel.end_time;
    self.phoneLab.text = _arrModel.institution_phone;
    _emailLab.text = _arrModel.institution_email;
    _urlLab.text = _arrModel.institution_url;
    _addressLab.text = _arrModel.institution_address;
    _cerLab.text = [NSString stringWithFormat:@"%@监管",self.agencyNameLab.text];
    if (_arrModel.certificate.length < 1) {
        self.cerLab.text = @"尚未上传";
        self.cerBtn.hidden = YES;
    }
    for (UILabel * label in _labArr) {
        if (label.text.length < 1) {
            label.text = @"--";
        }
    }
    
}
- (IBAction)cerBtnClick:(UIButton *)sender {
    CheckCertificateVC * checkVC = [[CheckCertificateVC alloc]init];
    checkVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    checkVC.imgUrl = _arrModel.certificate;
 
    [self presentViewController:checkVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
