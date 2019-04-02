//
//  CreateQuestionVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CreateQuestionVC.h"
#import "ChooseQTypeVC.h"
@interface CreateQuestionVC ()

@end

@implementation CreateQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topHeight.constant = TopHeight + 10;
    self.navigationItem.title = @"悬赏提问";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.moneyTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.questionTV];
    
    UITapGestureRecognizer * tfBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tfBVClick)];
    [self.categoryBV addGestureRecognizer: tfBVTGR];
    self.submitBtn.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}
-(void)tfBVClick
{
    ChooseQTypeVC * typeVC = [[ChooseQTypeVC alloc]init];
    WeakSelf;
    typeVC.submitBlock = ^(NSString *titleStr, NSString *idStr) {
        weakSelf.categoryLab.text = titleStr;
        weakSelf.typeId = idStr;
        weakSelf.categoryLab.textColor = RGBCOLOR(14, 124, 244);
        [weakSelf judgeContentView];
    };
    [self.navigationController pushViewController:typeVC animated:YES];
}
-(void)textFieldDidChange
{
    [self judgeContentView];
}
-(void)textViewDidChange
{
    [self judgeContentView];
    if (self.questionTV.text.length > 0) {
        self.holdLab.hidden = YES;
        
    }else{
        
        self.holdLab.hidden = NO;
    }
    if (self.questionTV.text.length > 120) {
        self.questionTV.text = [self.questionTV.text substringToIndex:120];
    }
    self.numberLab.text = [NSString stringWithFormat:@"%ld/120",self.questionTV.text.length];
}
//判断填写状态
-(void)judgeContentView
{
    if (self.questionTV.text.length > 9&&self.moneyTF.text.length > 0 && ![self.categoryLab.text isEqualToString:@"必选"]) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = RGBCOLOR(14, 123, 243);

    }else{
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = RGBCOLOR(239, 239, 239);
        
    }
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    if (![GYToolKit isPureInt:self.moneyTF.text]) {
        [SVProgressHUD showWithString:@"悬赏必须是整数哦~"];
        return;
    }
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_questionTV.text,@"question",_typeId,@"place",[UserInfo share].uId,@"uid",_moneyTF.text,@"price",nil];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JCreateQ Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                [SVProgressHUD showWithString:@"发布成功，请静待审核~"];
                [self postDataSucceed];
                
            }else{
                if ([jsonMessage[@"code"]integerValue] == 60000) {
                    
                    [SVProgressHUD dismiss];
                    WeakSelf;
                    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"余额不足，前往充值~" leftButtonTitle:@"取消" rightButtonTitle:@"前往"];
                    alert.rightBlock = ^{
                        [weakSelf goWalletVC];
                    };
                    [alert show];
                    return;
                }
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
-(void)goWalletVC
{
    MainWalletVC * walletVC = [[MainWalletVC alloc]init];
    [self.navigationController pushViewController:walletVC animated:YES];
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
