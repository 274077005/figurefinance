//
//  EditRegulationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditRegulationVC.h"
#import "WeDatePicker.h"
@interface EditRegulationVC ()
{
    PhotoPicker * _photoPicker;
    WeDatePicker* _dayPicker;
    NSArray * _keyArr;
    NSArray * _tfArr;
    NSArray * _mustArr; //必传的信息
    
}
@end

@implementation EditRegulationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加监管信息";
    self.topHeight.constant = TopHeight;
    
    _keyArr = @[@"license_type",@"supervision_number",@"start_time",@"end_time",@"institution",@"institution_phone",@"institution_email",@"institution_url",@"institution_address"];
    _tfArr = @[_typeTF,_numberTF,_beginTF,_endTF,_institutionTF,_phoneTF,_emailTF,_urlTF,_addressTF];
    _mustArr = @[_agencyNameLab,_typeTF,_numberTF,_beginTF,_institutionTF];
    UITapGestureRecognizer * agencyTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agencyBVClick)];
    [_agencyBV addGestureRecognizer:agencyTGR];
    UITapGestureRecognizer * beginTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginTimeBVClick)];
    [_beginTimeBV addGestureRecognizer:beginTGR];
    UITapGestureRecognizer * endTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeBVClick)];
    [_endTimeBV addGestureRecognizer:endTGR];
    _dayPicker = [[WeDatePicker alloc]init];
    if (_isEdit) {
        self.navigationItem.title = @"编辑监管信息";
        [self.changeAgencyBtn setTitle:@"更换机构" forState:UIControlStateNormal];
        [self.view bringSubviewToFront:_deleteBV];
        [self setUpContentView];
        self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
        [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    }else{
        self.reModel = [[CenterRegulationModel alloc]init];
    }
    
    
}
-(void)setUpContentView
{
    NSDictionary * modelDic = _reModel.mj_keyValues;
    //    _accountTF.text = _enModel.account;
    //
    for (NSInteger i = 0; i < _tfArr.count; i++) {
        UITextField * tf = _tfArr[i];
        
        tf.text = modelDic[_keyArr[i]];
    }
    [self.agencyImgV sd_setImageWithURL:IMG_URL(_reModel.logo_url)];
    self.agencyNameLab.text = _reModel.agency_name;
    [self setUpCerViews];
    self.cerAgencyLab.text = [NSString stringWithFormat:@"%@监管",self.agencyNameLab.text];
    
}
- (IBAction)changeAgencyBtnClick:(UIButton *)sender {
    [self agencyBVClick];
}
-(void)agencyBVClick
{
    [DialogView showWithNormal:self.cAgencyV];
    WeakSelf;
    self.cAgencyV.submitBlock = ^(CenterAgencyModel *agencyModel) {
        [weakSelf.agencyImgV sd_setImageWithURL:IMG_URL(agencyModel.logo_url)];
        weakSelf.agencyNameLab.text = agencyModel.agency_name;
        weakSelf.reModel.agency = agencyModel.theId;
        [weakSelf.changeAgencyBtn setTitle:@"更换机构" forState:UIControlStateNormal];
        weakSelf.cerAgencyLab.text = [NSString stringWithFormat:@"%@监管",weakSelf.agencyNameLab.text];
    };
}
- (UIView *)cAgencyV
{
    if (!_cAgencyV) {
        _cAgencyV =  [[[NSBundle mainBundle] loadNibNamed:@"ChooseAgencyV" owner:nil options:nil] lastObject];
        _cAgencyV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
        _cAgencyV.centerModel = self.centerModel;
    }
    return _cAgencyV;
    
}
-(void)beginTimeBVClick
{
    [self.view endEditing:YES];
    [_dayPicker showWithBlock:^(NSString * dateStr) {
        _beginTF.text = dateStr;
    }];
}
-(void)endTimeBVClick
{
    [_dayPicker showWithBlock:^(NSString * dateStr) {
        _endTF.text = dateStr;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
-(void)submitBtnClick
{
    [self SaveRegulationData];
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    [self SaveRegulationData];
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)uploadBtnClick:(UIButton *)sender {
    _photoPicker = [[PhotoPicker alloc]init];
    WeakSelf;
    _photoPicker.parentVC =self;
    //        weak_type(_photoPicker);
    _photoPicker.pickBlock = ^(UIImage* image){
        NSData *data = [GYToolKit compressImageQuality:image toKb:500];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        weakSelf.imgStr = imageStr;
        weakSelf.cerImg = image;
        [weakSelf setUpCerViews];
        
        //        [weakSelf postEditMessageWithKey:@"image" value:imageStr];
    };
    [_photoPicker pickWithSize:CGSizeZero ImageName:@"avatar_img.jpg"];
}
-(void)setUpCerViews
{
    if (_imgStr.length > 0 || _reModel.certificate.length > 0) {
        [self.certificateBV bringSubviewToFront:self.beCerBV];
        [self.uploadBtn setTitle:@"重新上传" forState:UIControlStateNormal];
    }else{
        [self.certificateBV bringSubviewToFront:self.noCerBV];
        [self.uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    }
}



- (IBAction)checkCerBtnClick:(UIButton *)sender {
    CheckCertificateVC * checkVC = [[CheckCertificateVC alloc]init];
    checkVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if (_imgStr.length > 1) {
        checkVC.cerImg = self.cerImg;
    }else{
        checkVC.imgUrl = _reModel.certificate;
    }
    [self presentViewController:checkVC animated:YES completion:nil];
}
- (IBAction)deleteCerBtnClick:(UIButton *)sender {
    _reModel.certificate = @"";
    _imgStr = @"";
    [self setUpCerViews];
}

//删除某个监管机构
- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    
    if (_isEdit) {
        [bodyDic setObject:self.reModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDeleteRegulatory Handler:^(NSDictionary * jsonMessage, NSError *error){
        
        if (!error) {
            if ([jsonMessage[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"提交成功~"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
-(void)SaveRegulationData
{
    
    for (NSInteger i = 0; i < _mustArr.count; i++) {
        UITextField * tf = _mustArr[i];
        if (tf.text.length < 1) {
            [SVProgressHUD showWithString:@"*号为必填项哦~"];
            return;
        }
    }
    
    if (_reModel.agency.length < 1) {
        [SVProgressHUD showWithString:@"*号为必填项哦~"];
        return;
    }
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i < _tfArr.count; i++) {
        UITextField * tf = _tfArr[i];
        [bodyDic setObject:tf.text forKey:_keyArr[i]];
    }
    [bodyDic setObject:_reModel.agency forKey:@"agency"];

    if (_imgStr.length > 0) {
        [bodyDic setObject:_imgStr forKey:@"certificate"];
    }
    if (_isEdit) {
        [bodyDic setObject:self.reModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveRegulatory Handler:^(NSDictionary * jsonMessage, NSError *error){
        
        if (!error) {
            if ([jsonMessage[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"提交成功~"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}

@end
