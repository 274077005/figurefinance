//
//  DlgCommentWayV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "DlgCommentWayV.h"

@implementation DlgCommentWayV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)replyBtnClick:(UIButton *)sender {
    
    [self close:nil];
    self.submitBlock(@"reply");
}
- (IBAction)delBtnClick:(UIButton *)sender {
    
    [self close:nil];
    self.submitBlock(@"delete");
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self close:nil];
}

@end
