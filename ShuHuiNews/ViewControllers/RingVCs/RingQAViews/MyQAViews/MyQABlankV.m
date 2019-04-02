//
//  MyQABlankV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MyQABlankV.h"
#import "CreateQuestionVC.h"
@implementation MyQABlankV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)goBtnClick:(UIButton *)sender {
    CreateQuestionVC * createVC = [[CreateQuestionVC alloc]init];
    [self.viewContoller.navigationController pushViewController:createVC animated:YES];
    
}

@end
