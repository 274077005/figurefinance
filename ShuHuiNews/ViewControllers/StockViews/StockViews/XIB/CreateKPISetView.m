//
//  CreateKPISetView.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/9/13.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "CreateKPISetView.h"

@implementation CreateKPISetView

//- (UIView *)createENVSetView
//{
//    if (!_envSetView) {
//        _envSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
//        _envSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        _envSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        [_envSetView setENVLables];
//        
//        __weak __typeof__(self) weakSelf = self;
//        self.envSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
//            _ENV1 = M1Value;
//            __strong __typeof(self) strongSelf = weakSelf;
//            [strongSelf didSetValueForKpiValue];
//        };
//    }
//    [self.envSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_ENV1] kpi2Value:0 kpi3Value:0];
//    return self.envSetView;
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
