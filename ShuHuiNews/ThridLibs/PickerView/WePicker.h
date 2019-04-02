//
//  WePicker.h
//  wemex
//
//  Created by Zach on 2017/12/15.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WePicker : UIView

- (void)showWithBlock:(CommBlock)blocker;
- (void)show:(id)data WithBlock:(CommBlock)blocker;

- (void)close;

- (void)addContentView:(UIView*)content;

- (void)onBtnOKtouched:(UIButton*)button;
    
@property(nonatomic, copy, readonly) CommBlock respBlocker;

@end
