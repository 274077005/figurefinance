//
//  EditRegulationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditPersonalBasicsVC.h"

@interface EditPersonalBasicsVC ()
{
    PhotoPicker * _photoPicker;
    
    NSArray * _tfArr;
    NSString * _imgStr;
}
@end

@implementation EditPersonalBasicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑基础信息";
    self.topHeight.constant = TopHeight;
    _imgStr = @"";
    
    
    [self setUpContentView];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    
    self.cardImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * imgVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick)];
    [self.cardImgV addGestureRecognizer: imgVTGR];
    
}

-(void)setUpContentView
{
    if (self.atModel.attestation_card.length > 0) {
        [_cardImgV sd_setImageWithURL:IMG_URL(_atModel.attestation_card)];
    }
    self.nameTF.text = _atModel.attestation_name;
    self.jobTF.text = _atModel.attestation_job;
    self.companyTF.text = _atModel.attestation_company;
    
}
- (void)imgVClick
{
    _photoPicker = [[PhotoPicker alloc]init];
    WeakSelf;
    _photoPicker.parentVC =self;
    //        weak_type(_photoPicker);
    _photoPicker.pickBlock = ^(UIImage* image){
        weakSelf.cardImgV.image = image;
        NSData *data = [GYToolKit compressImageQuality:image toKb:500];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        _imgStr = imageStr;
        //        [weakSelf postEditMessageWithKey:@"image" value:imageStr];
    };
    [_photoPicker pickWithSize:CGSizeZero ImageName:@"avatar_img.jpg"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
-(void)submitBtnClick
{
    if (_nameTF.text.length < 1 || _jobTF.text.length < 1 || _companyTF.text.length < 1 ) {
        [SVProgressHUD showWithString:@"请填写完整哦~"];
        return;
    }
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_nameTF.text forKey:@"attestation_name"];
    [bodyDic setObject:_jobTF.text forKey:@"attestation_job"];
    [bodyDic setObject:_companyTF.text forKey:@"attestation_company"];
    [bodyDic setObject:_imgStr forKey:@"attestation_card"];

    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSavePersonalAttestation Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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

//保存
@end
