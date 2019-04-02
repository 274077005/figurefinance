//
//  RingQAHeaderV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "QAListHeaderV.h"
#import "MyQCommentVC.h"
#import "MyQAListVC.h"
#import "CreateQuestionVC.h"
@implementation QAListHeaderV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)mainQABtnClick:(UIButton *)sender {
    
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    MyQAListVC * listVC = [[MyQAListVC alloc]init];
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];

}

- (IBAction)payBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    CreateQuestionVC * questionVC = [[CreateQuestionVC alloc]init];
    [self.viewContoller.navigationController pushViewController:questionVC animated:YES];
}
- (IBAction)evaluateBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    
    MyQCommentVC * myVC = [[MyQCommentVC alloc]init];
    [self.viewContoller.navigationController pushViewController:myVC animated:YES];
    
}

@end
