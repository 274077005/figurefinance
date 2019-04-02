//
//  SpecialHeaderV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SpecialHeaderV.h"

@implementation SpecialHeaderV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setUpContentView
{
    self.titleLab.text = _contentDic[@"course_name"];
    [self.coverImgV sd_setImageWithURL:IMG_URL(_contentDic[@"imageurl"])];

}
@end
