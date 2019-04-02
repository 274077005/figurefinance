//
//  DlgCommentV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/13.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "DlgCommentV.h"

@implementation DlgCommentV

-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.contentTV];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];

}
- (void)layoutSubviews
{
    [self.contentTV becomeFirstResponder];
    self.contentTV.text = @"";
    self.numberLab.text = @"0/100";
    self.holdLab.hidden = NO;
    [self.submitBtn setTitleColor:RGBCOLOR(170, 173, 176) forState:UIControlStateNormal];
    
    
}
- (IBAction)cancelBtnCLick:(UIButton *)sender {
    [self.contentTV endEditing:YES];
    [self close:nil];
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    if (_contentTV.text.length < 1) {
        [SVProgressHUD showWithString:@"评论内容不能为空哦~"];
        return;
    }
    if (self.submitBlock) {
        self.submitBlock(_contentTV.text);
    }
    [self close:nil];
    
}
-(void)textViewDidChange
{
    
    if (self.contentTV.text.length > 0) {
        
        self.holdLab.hidden = YES;
        [self.submitBtn setTitleColor:RGBCOLOR(0, 111, 255) forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitleColor:RGBCOLOR(170, 173, 176) forState:UIControlStateNormal];
        
        self.holdLab.hidden = NO;
    }
    if (self.contentTV.text.length > 100) {
        self.contentTV.text = [self.contentTV.text substringToIndex:100];
    }
    self.numberLab.text = [NSString stringWithFormat:@"%ld/100",self.contentTV.text.length];
    
}
- (void)dealloc
{
    NSLog(@"commentV dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification {

//    self.tvBottom.constant = 385;

    NSDictionary *dict = [notification userInfo];
    // 键盘弹出和收回的时间
    CGFloat duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘初始时刻的frame
    CGRect beginKeyboardRect = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 键盘停止后的frame
    CGRect endKeyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"end:%f",endKeyboardRect.origin.y);
    // 相减为键盘高度
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
//    NSLog(@"%f",yOffset);
    [UIView animateWithDuration:duration animations:^{
        
        //键盘弹出
        if (yOffset < 0) {
//            NSLog(@"弹出");
            self.tvBottom.constant = SCREEN_HEIGHT - endKeyboardRect.origin.y;
            [self layoutIfNeeded];

        }else{
            NSLog(@"隐藏");

        }
    }];

}

@end
