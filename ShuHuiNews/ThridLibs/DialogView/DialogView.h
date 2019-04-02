//
//  DialogView.h
//  wemex
//
//  Created by Zach on 2017/12/27.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import <UIKit/UIKit.h>

// SINGLETON
#define SINGLETON_DECLARE(CLS)          + (CLS*)shared;

#define SINGLETON_IMPLEMENTATION(CLS)   + (CLS*)shared { \
static CLS* instance = nil; \
if (instance == nil) {  instance = [[CLS alloc] init];  } \
return instance; }

#define SINGLETON_IMPLEMENTATION_FRAME(CLS, FRM)   + (CLS*)shared { \
static CLS* instance = nil; \
if (instance == nil) {  instance = [[CLS alloc] initWithFrame:FRM];  } \
return instance; }


typedef void (^CommBlock)(id sender);
@interface DialogView : UIView

SINGLETON_DECLARE(DialogView)

+ (void)showWithNormal:(UIView*)view;
+ (void)showWithTextFildView:(UIView*)view;
+ (void)showWithPop:(UIView*)view;

- (void)close:(CommBlock)closeAfterBlocker;
+ (void)close;
@end


@interface DialogBase : UIView

- (void)close:(CommBlock)closeAfterBlocker;

@end

