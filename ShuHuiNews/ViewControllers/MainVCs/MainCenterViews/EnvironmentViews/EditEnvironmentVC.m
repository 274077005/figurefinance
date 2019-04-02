//
//  EditRegulationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditEnvironmentVC.h"

@interface EditEnvironmentVC ()
{
    NSArray * _keyArr;
    NSArray * _tfArr;
}
@end

@implementation EditEnvironmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加交易环境";
    self.topHeight.constant = TopHeight;
    _keyArr = @[@"account",@"varieties",@"speed",@"type",@"min_num",@"min_money"];
    _tfArr = @[_accountTF,_varietiesTF,_speedTF,_typeTF,_minNumTF,_minMoneyTF];
    if (_isEdit) {
        self.navigationItem.title = @"编辑交易环境";
        [self.view bringSubviewToFront:_deleteBV];
        [self setUpContentView];
        self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
        [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    }

}

-(void)setUpContentView
{
    _accountTF.text = _enModel.account;
    
    for (NSInteger i = 0; i < self.enModel.content.count; i++) {
        TheEnvironmentModel * theModel = self.enModel.content[i];
        UITextField * tf = _tfArr[i+1];
        tf.text = theModel.content;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
-(void)submitBtnClick
{
    [self SaveEnvironmentData];
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    [self SaveEnvironmentData];
}
-(void)SaveEnvironmentData
{
    
    for (NSInteger i = 0; i < _tfArr.count; i++) {
        UITextField * tf = _tfArr[i];
        if (tf.text.length < 1) {
            [SVProgressHUD showWithString:@"请补充完整哦~"];
            return;
        }
    }
    if (![GYToolKit isNum:_speedTF.text]) {
        [SVProgressHUD showWithString:@"交易速度请输入数字类型哦~"];
        return;
    }
    if (![GYToolKit isNum:_minNumTF.text]) {
        [SVProgressHUD showWithString:@"交易手数请输入数字类型哦~"];
        return;
    }
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i < _tfArr.count; i++) {
        UITextField * tf = _tfArr[i];
        [bodyDic setObject:tf.text forKey:_keyArr[i]];
    }
    
    if (_isEdit) {
        [bodyDic setObject:self.enModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveEnvironment Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];

    if (_isEdit) {
        [bodyDic setObject:self.enModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDeleteEnvironment Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
