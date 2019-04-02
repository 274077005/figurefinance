//
//  AddAddressVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AddAddressVC.h"
#import "CityPicker.h"
@interface AddAddressVC ()
{
    NSArray * _tfArr;
}

@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增收货地址";
    self.topHeight.constant = TopHeight;
    _tfArr = @[_nameTF,_phoneTF,_cityTF,_addressTF];
    
    UITapGestureRecognizer * cityBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityBVClick)];
    [self.cityBV addGestureRecognizer: cityBVTGR];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    for (UITextField * tf in _tfArr) {
        if (tf.text.length < 1) {
            [SVProgressHUD showWithString:@"信息尚未填写完整哦~"];
            return;
        }
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_nameTF.text forKey:@"name"];
    [bodyDic setObject:_phoneTF.text forKey:@"telephone"];
    [bodyDic setObject:_cityTF.text forKey:@"city"];
    [bodyDic setObject:_addressTF.text forKey:@"address"];

    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JAddAddress Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                if (self.saveBlock) {
                    self.saveBlock();
                }
                
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
