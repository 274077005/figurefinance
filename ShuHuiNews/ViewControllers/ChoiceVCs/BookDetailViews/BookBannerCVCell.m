//
//  BookBannerCVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookBannerCVCell.h"

@implementation BookBannerCVCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CALayer *layer = [[CALayer alloc] init];
    layer.position = _coverImgV.layer.position;
    layer.bounds = _coverImgV.bounds;
 
    
    layer.cornerRadius = _coverImgV.layer.cornerRadius;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.4;
    [self.layer addSublayer:layer];
    [self bringSubviewToFront:_coverImgV];
}
@end
