//
//  EiditCompanyInfoVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditPersonalInfoVC.h"
#import "SexPcker.h"
@interface EditPersonalInfoVC ()
{
    SexPcker * _sexPicker;
}

@end

@implementation EditPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑个人简介";
    self.topHeight.constant = TopHeight;
    
    
    [self setUpContentView];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.abstractTV];

    UITapGestureRecognizer * sexBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexBVClick)];
    [self.sexBV addGestureRecognizer: sexBVTGR];
    // Do any additional setup after loading the view from its nib.
}
-(void)sexBVClick
{
    
    _sexPicker = [[SexPcker alloc]init];
    [_sexPicker show:nil WithBlock:^(id sender) {
        if ([sender[@"code"] integerValue] == 1) {
            _basicModel.sex = 1;
            _sexTF.text = @"男";
        }else{
            _basicModel.sex = 2;
            _sexTF.text = @"女";
        }
       
    }];
}
-(void)setUpContentView
{
    self.nameTF.text = _basicModel.nickname;
    if (_basicModel.sex == 1) {
        self.sexTF.text = @"男";
    }else{
        self.sexTF.text = @"女";
    }
    self.abstractTV.text = _basicModel.desc;
    
    [self textViewDidChange];
}
- (void)submitBtnClick
{
    if (self.nameTF.text.length < 1) {
        [SVProgressHUD showWithString:@"请填昵称~"];
        return;
    }
    if (self.sexTF.text.length < 1) {
        [SVProgressHUD showWithString:@"请选择性别~"];
        return;
    }
    _basicModel.nickname = self.nameTF.text;
    _basicModel.desc = self.abstractTV.text;
    NSDictionary * modelDic = _basicModel.mj_keyValues;
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]initWithDictionary:modelDic];
    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSavePersonalBasicInfo Handler:^(NSDictionary * jsonMessage, NSError *error){
   
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
