//
//  NotLoginV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "NotLoginV.h"

@implementation NotLoginV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)loginBtnClick:(UIButton *)sender {
    [GYToolKit pushLoginVC];
    
}

@end
