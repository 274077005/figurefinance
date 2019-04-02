//
//  GYTimer.h
//  GYTimer
//
//  Created by zzw on 2018/5/7.
//  Copyright © 2018年 zzw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYTimer;
@protocol GYTimerDelegate <NSObject>
@required
- (void)onTimerClick:(GYTimer*)timer;
@end
@interface GYTimer : NSObject

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<GYTimerDelegate>)delegate
           repeats:(BOOL)repeats;

- (void)startGCDTimer:(NSTimeInterval)seconds
             delegate:(id<GYTimerDelegate>)delegate;

- (void)stopTimer;
//暂停定时器
- (void)goFuture;
//开启定时器
- (void)goPast;

@end
