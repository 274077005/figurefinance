//
//  YYRegisterViewController.m
//  Treasure
//
//  Created by 耿一 on 16/6/20.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "RegisterViewController.h"
#import "GYPostData+main.h"
#import "BaseWebVC.h"
@interface RegisterViewController ()
{
    
    NSInteger _timeNum;
    NSTimer *_timer;
    BOOL _isSelect;
    BOOL _isPopup;
    
}
@end

@implementation RegisterViewController
//隐藏显示navigationBar
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(248, 249, 250);
    
    
    
    if (self.openId.length > 0) {
        self.navigationItem.title = @"绑定账户";
    }else{
        self.navigationItem.title = @"账户注册";
    }
    
    
    self.userType = @"2";
    _timeNum = 60;
    _isSelect = YES;
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTF.keyboardType = UIKeyboardTypeNamePhonePad;

    
    [self createTimer];

    
    _passwordTF.secureTextEntry = !_passwordTF.secureTextEntry;
    self.topHeight.constant = TopHeight + 20;


    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.verifyNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer * areaTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaLabClick)];
    [self.areaLab addGestureRecognizer: areaTGR];
    
    UITapGestureRecognizer * personBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personBVClick)];
    [self.personBV addGestureRecognizer: personBVTGR];
    
    UITapGestureRecognizer * companyBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyBVClick)];
    [self.companyBV addGestureRecognizer: companyBVTGR];
    // Do any additional setup after loading the view from its nib.
}
-(void)areaLabClick
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
    _areaLab.text = areaStr;
    
}
- (void)personBVClick
{
     self.userType = @"2";
    self.personImgV.hidden = NO;
    self.companyImgV.hidden = YES;
}
- (void)companyBVClick
{
     self.userType = @"1";
    self.personImgV.hidden = YES;
    self.companyImgV.hidden = NO;
}
- (void)textFieldDidChange
{
    if ([_phoneNumTF.text length] >0 && [_verifyNumTF.text length] > 0 && [_passwordTF.text length] > 0) {
        _registerBtn.alpha = 1.0;
    }else{
        _registerBtn.alpha = 0.5;
    }
}


- (IBAction)getVerifyNumBtnClick:(id)sender {

    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[NSString stringWithFormat:@"%@ %@",_areaLab.text,_phoneNumTF.text] forKey:@"tel"];
    if (self.openId.length > 0) {
        [bodyDic setObject:self.openId forKey:@"openid"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JGetVerifyNum Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [SVProgressHUD showWithString:@"验证码发送成功"];
            [_timer setFireDate:[NSDate distantPast]];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];

}


- (IBAction)protocolBtnClick:(id)sender {
    _isSelect = !_isSelect;
    if (_isSelect) {
        [_protocolBtn setImage:[UIImage imageNamed:@"checkP"] forState:UIControlStateNormal];
    }else{
        [_protocolBtn setImage:[UIImage imageNamed:@"unCheckP"] forState:UIControlStateNormal];
    }
}

- (IBAction)protocolDetailBtnClick:(id)sender {
    
    BaseWebVC *webView = [[BaseWebVC alloc]init];
    
    webView.urlStr =  [NSString stringWithFormat:@"%@zixun/agree",Main_Url];
    
    
    
    [self.navigationController pushViewController:webView animated:YES];
    
}
//创建定时器控制获取验证码操作
-(void)createTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeVerifyBtnTime) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)changeVerifyBtnTime{
    NSString *str = [NSString stringWithFormat:@"%ld秒后重发",_timeNum];
    _getVerifyNumBtn.titleLabel.text = str;
    [_getVerifyNumBtn setTitle:str forState:UIControlStateNormal];
    _getVerifyNumBtn.userInteractionEnabled = NO;
    [_getVerifyNumBtn setTitleColor:RGBCOLOR(211, 78, 95) forState:UIControlStateNormal];

    if (0 == _timeNum) {
        [_timer setFireDate:[NSDate distantFuture]];
        _timeNum = 60;
        [_getVerifyNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerifyNumBtn setTitleColor:RGBCOLOR(131, 135, 136) forState:UIControlStateNormal];
        _getVerifyNumBtn.userInteractionEnabled = YES;
    }
    _timeNum --;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    [_verifyNumTF resignFirstResponder];

}
- (IBAction)registBtnClick:(id)sender {
    if(!_isSelect){
        [SVProgressHUD showWithString:@"请同意数汇资讯用户注册协议"];
        return;
    }

    if(_verifyNumTF.text.length < 1){
        [SVProgressHUD showWithString:@"验证码不能为空哦"];
        return;
    }
    if(_passwordTF.text.length < 6){
        [SVProgressHUD showWithString:@"密码最少6位哦"];
        return;
    }
    
    NSMutableDictionary *accountDIc = [[NSMutableDictionary alloc]init];
    [accountDIc setObject:[NSString stringWithFormat:@"%@ %@",_areaLab.text,_phoneNumTF.text] forKey:@"tel"];
    [accountDIc setObject:_passwordTF.text forKey:@"pwd"];
    [accountDIc setObject:_verifyNumTF.text forKey:@"notecode"];
    [accountDIc setObject:_userType forKey:@"attestation_type"];

    if (self.openId.length > 0) {
        [accountDIc setObject:self.openId forKey:@"openid"];
        if ([self.thridType isEqualToString:@"weChat"]) {
            [accountDIc setObject:@"1" forKey:@"type"];
        }else{
            [accountDIc setObject:@"2" forKey:@"type"];
        }
        
    }
    

    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:accountDIc UrlPath:JRegister Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            if (self.openId.length > 0) {
                [SVProgressHUD showWithString:@"绑定成功"];
            }else{
                [SVProgressHUD showWithString:@"注册成功"];
            }
            
            
            [self loginSuccessWithJsonMessage:jsonMessage[@"data"]];
            

        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
- (void)loginSuccessWithJsonMessage:(NSDictionary *)jsonMessage
{
    
    [UserInfo saveUserInfoWithJsonMessage:jsonMessage];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
