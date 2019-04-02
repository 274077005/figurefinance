//
//  NoPWLoginVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "NoPWLoginVC.h"

@interface NoPWLoginVC ()
{
    
    NSInteger _timeNum;
    NSTimer *_timer;

    
}
@end

@implementation NoPWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"免密登录";
    self.topHeight.constant = TopHeight + 20;
    
    _timeNum = 60;
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self createTimer];
    
    UITapGestureRecognizer * areaTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaLabClick)];
    [self.areaLab addGestureRecognizer: areaTGR];
    
    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.verifyNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}
- (void)textFieldDidChange
{
    if ([_phoneNumTF.text length] >0 && [_verifyNumTF.text length] > 0 ) {
        _registerBtn.alpha = 1.0;
    }else{
        _registerBtn.alpha = 0.5;
    }
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
//创建定时器控制获取验证码操作
-(void)createTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeVerifyBtnTime) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (IBAction)getVerifyNumBtnClick:(id)sender {

    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[NSString stringWithFormat:@"%@ %@",_areaLab.text,_phoneNumTF.text] forKey:@"tel"];
  
    [bodyDic setObject:@"pureGet" forKey:@"openid"];
    
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
- (IBAction)pwLoginBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registBtnClick:(id)sender {

    if(_verifyNumTF.text.length < 1){
        [SVProgressHUD showWithString:@"验证码不能为空哦"];
        return;
    }

    
    NSMutableDictionary *accountDIc = [[NSMutableDictionary alloc]init];
    [accountDIc setObject:[NSString stringWithFormat:@"%@ %@",_areaLab.text,_phoneNumTF.text] forKey:@"tel"];

    [accountDIc setObject:_verifyNumTF.text forKey:@"code"];

    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:accountDIc UrlPath:JNoPWLogin Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {

            [SVProgressHUD showWithString:@"登录成功"];

            
            
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumTF resignFirstResponder];
    [_verifyNumTF resignFirstResponder];
    
}

@end
