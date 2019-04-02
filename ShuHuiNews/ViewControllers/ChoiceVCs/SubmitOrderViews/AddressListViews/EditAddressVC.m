//
//  EditAddressVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditAddressVC.h"
#import "CityPicker.h"
@interface EditAddressVC ()
{
    NSArray * _tfArr;
}
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑收货地址";
    self.topHeight.constant = TopHeight;
    _tfArr = @[_nameTF,_phoneTF,_cityTF,_addressTF];
    [self updateWithModel];
    UITapGestureRecognizer * cityBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityBVClick)];
    [self.cityBV addGestureRecognizer: cityBVTGR];
}
- (void)updateWithModel
{
    self.nameTF.text = _addModel.name;
    self.phoneTF.text = _addModel.telephone;
    self.cityTF.text = _addModel.city;
    self.addressTF.text = _addModel.address;
    
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    for (UITextField * tf in _tfArr) {
        if (tf.text.length < 1) {
            [SVProgressHUD showWithString:@"信息尚未填写完整哦~"];
            return;
        }
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_addModel.theId forKey:@"address_id"];
    [bodyDic setObject:_nameTF.text forKey:@"name"];
    [bodyDic setObject:_phoneTF.text forKey:@"telephone"];
    [bodyDic setObject:_cityTF.text forKey:@"city"];
    [bodyDic setObject:_addressTF.text forKey:@"address"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JAddAddress Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"编辑成功~"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonDic[@"msg"]];
            }
        }
    }];
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    [GYToolKit createAlertWith:nil message:@"确定删除此收货地址么？" action:^(UIAlertAction * _Nonnull action) {
        [self deleteAddress];
    } target:self];
   
}
-(void)deleteAddress
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_addModel.theId forKey:@"address_id"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDelAddress Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"删除成功"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonDic[@"msg"]];
            }
        }
    }];
}
- (void)cityBVClick
{
    [[CityPicker shared] show:nil WithBlock:^(NSDictionary * dic) {
        
        self.cityTF.text = dic[@"title"];
        
        
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
