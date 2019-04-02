//
//  LoginViewController.m
//  Wanyuanbao
//
//  Created by 耿一 on 2017/10/24.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import "LoginViewController.h"
#import "LostPwVC.h"
#import "RegisterViewController.h"
#import "GYPostData+main.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)hidePasswordBtnClick:(id)sender {
    _passwordTF.secureTextEntry = !_passwordTF.secureTextEntry;
    NSString *content = _passwordTF.text;
    _passwordTF.text = @"";
    _passwordTF.text = content;
    if (_passwordTF.secureTextEntry) {
        [_passwordTF insertText:content];
        [_hidePasswordBtn setImage:[UIImage imageNamed:@"disPw"] forState:UIControlStateNormal];
    }else{
        [_hidePasswordBtn setImage:[UIImage imageNamed:@"showPw"] forState:UIControlStateNormal];
    }
}

- (IBAction)losePasswordBtnClick:(id)sender {
    LostPwVC *lpvc = [[LostPwVC alloc] init];
    lpvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:lpvc animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    rvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(248, 249, 250);
    //    UINavigationBar * bar = self.navigationController.navigationBar;
    //    /*风格,会影响状态栏的显示
    //     UIBarStyleDefault 状态栏为黑色
    //     UIBarStyleBlack 状态栏显示为白色
    //     */
    //    bar.barStyle = UIBarStyleDefault;
    //
    self.navigationItem.title = @"账户登录";
    
    self.topHeight.constant = TopHeight + 16;
    
    
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _passwordTF.secureTextEntry = !_passwordTF.secureTextEntry;
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"loginClose"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    
    
    UITapGestureRecognizer * areaTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaLabClick)];
    [self.areaLab addGestureRecognizer: areaTGR];
    
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"游客登录" style:UIBarButtonItemStylePlain target:self action:@selector(fakeBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:RGBCOLOR(96, 97, 98)];
    
    
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
- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏显示navigationBar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //当plist里设置为NO时，这样设置有效果
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

- (void)textFieldDidChange{
    NSString * userStr = _phoneNumTF.text;
    NSString * passStr = _passwordTF.text;
    if ([userStr length] >0 && [passStr length] > 0) {
        _loginBtn.alpha = 1.0;
    }else{
        _loginBtn.alpha = 0.5;
    }
    
}
//第三方登陆按钮点击
- (IBAction)thridLoginBtnClick:(UIButton *)sender {
    
    NSInteger loginType;
    if (sender.tag == 0) {
        loginType = SSDKPlatformTypeWechat;
    }else{
        loginType = SSDKPlatformTypeSinaWeibo;
    }
    
    [ShareSDK authorize:loginType settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid:%@",user.uid);
            NSLog(@"icon:%@",user.icon);
            NSLog(@"credential:%@",user.credential);
            NSLog(@"token:%@",user.credential.token);
            NSLog(@"nickname:%@",user.nickname);
            if (loginType == SSDKPlatformTypeWechat) {
                [self weChatLogin:user];
            }else{
                [self sinaLogin:user];
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
}
- (void)weChatLogin:(SSDKUser *)user
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.credential.uid,@"openid",nil];
    [SVProgressHUD show];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JWeChatLogin Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                if ([jsonMessage[@"data"][@"isBind"]integerValue] == 1) {
                    [SVProgressHUD showWithString:@"已绑定账号,正在登录~"];
                    [self loginSuccessWithJsonMessage:jsonMessage[@"data"]];
                }else{
                    RegisterViewController * bindVC = [[RegisterViewController alloc]init];
                    bindVC.thridType = @"weChat";
                    bindVC.openId = user.credential.uid;
                    
                    [self.navigationController pushViewController:bindVC animated:YES];
                }
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
- (void)sinaLogin:(SSDKUser *)user
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.credential.uid,@"id",nil];
    [SVProgressHUD show];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JSinaLogin Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                if ([jsonMessage[@"data"][@"isBind"]integerValue] == 1) {
                    [SVProgressHUD showWithString:@"已绑定账号,正在登录~"];
                    [self loginSuccessWithJsonMessage:jsonMessage[@"data"]];
                }else{
                    RegisterViewController * bindVC = [[RegisterViewController alloc]init];
                    bindVC.thridType = @"sina";
                    bindVC.openId = user.credential.uid;
                    [self.navigationController pushViewController:bindVC animated:YES];
                }
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
- (IBAction)loginBtnClick:(id)sender {
    
    
//    if (![GYToolKit isMobileNumber:_phoneNumTF.text]) {
//        [SVProgressHUD showWithString:@"请输入正确的手机号码"];
//        return;
//    }
    if(_passwordTF.text.length < 1){
        [SVProgressHUD showWithString:@"密码不能为空"];
        return;
    }
    
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",_areaLab.text,_phoneNumTF.text],@"tel",_passwordTF.text,@"pwd",nil];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JLogin Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                [SVProgressHUD showWithString:@"登录成功"];
                
                [self loginSuccessWithJsonMessage:jsonMessage[@"data"]];
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}

- (void)loginSuccessWithJsonMessage:(NSDictionary *)jsonMessage
{
    
    [UserInfo saveUserInfoWithJsonMessage:jsonMessage];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)fakeBtnClick{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"+86 18888888888",@"tel",@"123456",@"pwd",nil];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JLogin Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                [self loginSuccessWithJsonMessage:jsonMessage[@"data"]];
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
- (IBAction)verifyLoginBtnClick:(UIButton *)sender {
    NoPWLoginVC * noVC = [[NoPWLoginVC alloc]init];
    [self.navigationController pushViewController:noVC animated:YES];
    
}

- (void)dealloc
{
    NSLog(@"Login dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

