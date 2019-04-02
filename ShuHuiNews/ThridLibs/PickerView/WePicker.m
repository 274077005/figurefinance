//
//  WePicker.m
//  wemex
//
//  Created by Zach on 2017/12/15.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import "WePicker.h"

#define PICKER_H        300
#define BTN_PANEL_H     44
#define BTN_W           64

#define RGB_MAIN_V2         RGB(0x0CCFF2)

@interface WePicker()
{
    UIView* m_box;
    UIButton* m_bgBtn;
    CommBlock m_blocker;
}
@end

@implementation WePicker

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.backgroundColor = [UIColor clearColor];
        
        m_bgBtn = newButton(@[rect2id(self.bounds), self, sel2id(close)]);
        m_bgBtn.backgroundColor = RGBA(0x000000, 0.3);
        [self addSubview:m_bgBtn];
        m_bgBtn.alpha = 0;
        
        m_box = newView(@[rect2id(CGRectMake(10, SCREEN_HEIGHT, SCREEN_WIDTH-20, PICKER_H+4))]);
        m_box.backgroundColor = RGB(0xffffff);
        m_box.clipsToBounds = YES;
        m_box.layer.cornerRadius = 4;
        [self addSubview:m_box];
        
        UIView* line = newView(@[rect2id(CGRectMake(0, BTN_PANEL_H, m_box.fw, 0.5)), RGB(0xededed)]);
        [m_box addSubview:line];
        
        UIButton* btn_cancle = newButton(@[rect2id(CGRectMake(0, 0, BTN_W, BTN_PANEL_H)), self, sel2id(close)]);
        btn_cancle.titleLabel.font = Font(16);
        [btn_cancle setTitle:@"取消" forState:0];
        [btn_cancle setTitleColor:RGB(0xCCCCCC) forState:0];
        [m_box addSubview:btn_cancle];
        
        UIButton* btn_ok = newButton(@[rect2id(CGRectMake(m_box.fw-BTN_W, 0, BTN_W, BTN_PANEL_H)), self, sel2id(onBtnOKtouched:)]);
        btn_ok.titleLabel.font = Font(16);
        [btn_ok setTitle:@"确定" forState:0];
        [btn_ok setTitleColor:RGB_MAIN_V2 forState:0];
        [m_box addSubview:btn_ok];
    }
    return self;
}

- (void)addContentView:(UIView*)content {
    content.frame = CGRectMake(0, BTN_PANEL_H, m_box.fw, PICKER_H-BTN_PANEL_H);
    [m_box addSubview:content];
}
- (void)showWithBlock:(CommBlock)blocker {
    _respBlocker = blocker;
    
    m_box.fy = SCREEN_HEIGHT;
    m_bgBtn.alpha = 0.0;
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        m_box.fy = SCREEN_HEIGHT - PICKER_H;
        m_bgBtn.alpha = 1.0;
    }];
}
- (void)show:(id)data WithBlock:(CommBlock)blocker {
    _respBlocker = blocker;
    
    m_box.fy = SCREEN_HEIGHT;
    m_bgBtn.alpha = 0.0;
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        m_box.fy = SCREEN_HEIGHT - PICKER_H;
        m_bgBtn.alpha = 1.0;
    }];
}

- (void)close {
    [UIView animateWithDuration:0.2 animations:^{
        m_box.fy = SCREEN_HEIGHT;
        m_bgBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onBtnOKtouched:(id)sender {
    
}

@end
