//
//  EiditCompanyInfoVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditCompanyInfoVC.h"

@interface EditCompanyInfoVC ()

@end

@implementation EditCompanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑公司简介";
    self.topHeight.constant = TopHeight;
    
    
    [self setUpContentView];
    
    UITapGestureRecognizer * industryBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(industryBVClick)];
    [self.industryBV addGestureRecognizer: industryBVTGR];
    
    
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.abstractTV];
    // Do any additional setup after loading the view from its nib.
}
-(void)industryBVClick
{
    ChooseIndustryVC * industryVC = [[ChooseIndustryVC alloc]init];
    industryVC.industryType = @"4";
    industryVC.submitBlock = ^(NSString *titleStr, NSString *idStr) {
        _industryTF.text = titleStr;
    };
    [self.navigationController pushViewController:industryVC animated:YES];
}
-(void)setUpContentView
{
    self.nameTF.text = _basicModel.nickname;
    self.industryTF.text = _basicModel.industry_name;
    self.abstractTV.text = _basicModel.desc;
    [self textViewDidChange];
}
- (void)submitBtnClick
{
    if (self.nameTF.text.length < 1) {
        [SVProgressHUD showWithString:@"请填写品牌名~"];
        return;
    }
    if (self.industryTF.text.length < 1) {
        [SVProgressHUD showWithString:@"请填写行业名~"];
        return;
    }
    _basicModel.nickname = self.nameTF.text;
    _basicModel.industry_name = self.industryTF.text;
    _basicModel.desc = self.abstractTV.text;
    NSDictionary * modelDic = _basicModel.mj_keyValues;
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]initWithDictionary:modelDic];
    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveBasicInfo Handler:^(NSDictionary * jsonMessage, NSError *error){
   
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
-(void)textViewDidChange
{    
    //计算textView高度并向上取整
    NSInteger height = ceilf([_abstractTV sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)].height);

    self.tvHeight.constant = height + 30;
    [self.tvBV layoutIfNeeded];
    [self.tvBV layoutSubviews];

    
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
