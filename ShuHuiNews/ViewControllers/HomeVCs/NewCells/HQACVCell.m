//
//  HColumnICVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HQACVCell.h"

@implementation HQACVCell




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CALayer *layer = [[CALayer alloc] init];
    layer.position = _backV.layer.position;
    layer.bounds = _backV.bounds;
    layer.cornerRadius = _backV.layer.cornerRadius;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.2;
    [self.layer addSublayer:layer];
    [self bringSubviewToFront:_backV];

}


@end
