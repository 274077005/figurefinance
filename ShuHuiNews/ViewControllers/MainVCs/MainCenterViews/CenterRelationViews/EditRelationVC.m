//
//  EditRelationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditRelationVC.h"


@interface EditRelationVC ()
{
    NSInteger _areaType;
}

@end

@implementation EditRelationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑联系方式";
    self.topHeight.constant = TopHeight;
    
    [self setUpContentView];
    
    UITapGestureRecognizer * firstTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstAreaTFClick)];
    [self.fAreaLab addGestureRecognizer: firstTGR];
    
    UITapGestureRecognizer * secondTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondAreaTFClick)];
    [self.sAreaLab addGestureRecognizer: secondTGR];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    // Do any additional setup after loading the view from its nib.
}
-(void)firstAreaTFClick
{
    
    _areaType = 0;
    [self areaTFClick];
}
-(void)secondAreaTFClick
{
    _areaType = 1;
    [self areaTFClick];
}
-(void)areaTFClick
{
    [self.view endEditing:YES];
    ProvidePickerV *pickerV = [[ProvidePickerV alloc]init];
    
    pickerV.delegate = self;
    pickerV.arrayType = countryType;
    [KeyWindow addSubview:pickerV];
}
//国家区号选择
- (void)PickerSelectorIndixString:(NSString *)str{
    NSArray * arr = [str componentsSeparatedByString:@")"];
    NSString * firstStr = arr.firstObject;
    NSString * areaStr = [firstStr componentsSeparatedByString:@"("].lastObject;
    if (_areaType == 0) {
        _fAreaLab.text = areaStr;
    }else{
        _sAreaLab.text = areaStr;
    }
}
-(void)setUpContentView
{
    self.wechatTF.text = _contactModel.wechat;
    self.emailTF.text = _contactModel.email;

    //如果手机号没有保存过 则不初始化
    if (_contactModel.phone.length < 1) {
        return;
    }
    NSArray * phoneArr = [_contactModel.phone componentsSeparatedByString:@"/"];
    if (phoneArr.count > 1) {
        NSArray * fPhoneArr = [phoneArr.firstObject componentsSeparatedByString:@" "];
        _fAreaLab.text = fPhoneArr.firstObject;
        _fPhoneTF.text = fPhoneArr.lastObject;
        
        NSArray * sPhoneArr = [phoneArr.lastObject componentsSeparatedByString:@" "];
        _sAreaLab.text = sPhoneArr.firstObject;
        _sPhoneTF.text = sPhoneArr.lastObject;
    }else{
        NSArray * fPhoneArr = [phoneArr.firstObject componentsSeparatedByString:@" "];
        _fAreaLab.text = fPhoneArr.firstObject;
        _fPhoneTF.text = fPhoneArr.lastObject;
    }
}

- (void)submitBtnClick
{
    if (_fPhoneTF.text.length < 1 &&_sPhoneTF.text.length < 1) {
        [SVProgressHUD showWithString:@"最少填写一个联系电话~"];
        return;
    }
    
    if ((_fAreaLab.text.length < 1 || _fPhoneTF.text.length < 1)&&(_sAreaLab.text.length < 1 || _sPhoneTF.text.length < 1)) {
        [SVProgressHUD showWithString:@"最少填写一个正确的联系电话~"];
        return;
    }
    if ((_fAreaLab.text.length < 1 || _fPhoneTF.text.length < 1)&&(_sAreaLab.text.length > 1 && _sPhoneTF.text.length > 1)) {
        [SVProgressHUD showWithString:@"第一个联系电话不正确~"];
        return;
    }
    NSMutableString * phoneStr = [[NSMutableString alloc]init];
    [phoneStr appendString:_fAreaLab.text];
    [phoneStr appendString:@" "];
    [phoneStr appendString:_fPhoneTF.text];
    if (_sAreaLab.text.length > 0 && _sPhoneTF.text.length > 0) {
        [phoneStr appendString:@"/"];
        [phoneStr appendString:_sAreaLab.text];
        [phoneStr appendString:@" "];
        [phoneStr appendString:_sPhoneTF.text];
    }

    _contactModel.phone = phoneStr;
    _contactModel.wechat = _wechatTF.text;
    _contactModel.email = _emailTF.text;
    
    NSDictionary * modelDic = _contactModel.mj_keyValues;
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]initWithDictionary:modelDic];
    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveContact Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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
