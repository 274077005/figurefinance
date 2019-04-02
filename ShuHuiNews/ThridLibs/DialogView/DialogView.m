//
//  DialogView.m
//  wemex
//
//  Created by Zach on 2017/12/27.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import "DialogView.h"

#define SHOW_WITH_NORMAL    1
#define SHOW_WITH_POP       2

@interface DialogView ()
{
    UIView* bgView;
    int show_type;
    UIView* m_dialog;
}
@end

@implementation DialogView

SINGLETON_IMPLEMENTATION(DialogView)

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.alpha = 0.0;
        bgView = [[UIView alloc]initWithFrame:self.bounds];
        UITapGestureRecognizer * bgTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(to_close)];
        [bgView addGestureRecognizer:bgTGR];
        
        bgView.backgroundColor = RGBA(0x000000, 0.5);
        [self addSubview:bgView];
        [KeyWindow addSubview:self];
    }
    return self;
}
- (void)to_close {
    
    [self close:NULL];
}
+ (void)close{
    [[DialogView shared] close:NULL];
}
- (void)close:(CommBlock)closeAfterBlocker {
    if (show_type == SHOW_WITH_NORMAL) {
        [self normal_close:closeAfterBlocker];
    } else if (show_type == SHOW_WITH_POP){
        [self pop_close:closeAfterBlocker];
    }
}

+ (void)showWithTextFildView:(UIView*)view {
    [[DialogView shared] showTFV:view];
}
- (void)showTFV:(UIView*)dialog {
    show_type = SHOW_WITH_NORMAL;
    m_dialog = dialog;
    
    dialog.cx = self.fw / 2;
    dialog.cy = self.fh / 3;
    [self addSubview:dialog];
    
    self.alpha = 0.0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

//------------------------------------------------------------------------------------------------
+ (void)showWithNormal:(UIView*)view {
    [[DialogView shared] normal_show:view];
}

- (void)normal_show:(UIView*)dialog {
    show_type = SHOW_WITH_NORMAL;
    m_dialog = dialog;
    
    dialog.cx = self.fw / 2;
    dialog.cy = self.fh / 2;
    [self addSubview:dialog];
    
    self.alpha = 0.0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)normal_close:(CommBlock)closeAfterBlocker {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        show_type = 0;
        self.hidden = YES;
        [m_dialog removeFromSuperview];
        m_dialog = nil;
        if (closeAfterBlocker) {
            closeAfterBlocker(nil);
        }
    }];
}
//------------------------------------------------------------------------------------------------
+ (void)showWithPop:(UIView*)view {
    [[DialogView shared] pop_show:view];
}

- (void)pop_show:(UIView*)dialog {
    show_type = SHOW_WITH_POP;
    m_dialog = dialog;
    
    NSLog(@"%f",self.fh);
    
    dialog.fx = 0;
    dialog.fy = self.fh;
    [self addSubview:dialog];
    
    self.alpha = 0.0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        dialog.fy = self.fh - dialog.fh;
    }];
}

- (void)pop_close:(CommBlock)closeAfterBlocker {
    show_type = 0;
    self.hidden = YES;
    [m_dialog removeFromSuperview];
    m_dialog = nil;
    self.alpha = 0.0;
    m_dialog.fy = self.fh;
//    [UIView animateWithDuration:0.0 animations:^{
//        self.alpha = 0.0;
//        m_dialog.fy = self.fh;
//    } completion:^(BOOL finished) {
//        show_type = 0;
//        self.hidden = YES;
//        [m_dialog removeFromSuperview];
//        m_dialog = nil;
//        if (closeAfterBlocker) {
//            closeAfterBlocker(nil);
//        }
//    }];
}
//------------------------------------------------------------------------------------------------


@end




@implementation DialogBase

- (void)close:(CommBlock)closeAfterBlocker {
    [[DialogView shared] close:closeAfterBlocker];
}

@end
