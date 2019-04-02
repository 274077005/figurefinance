//
//  HomeCVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeCVCell.h"

@implementation HomeCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //实例化数据源
//        self.contentView.backgroundColor = randomColor;
        
    }
    return self;
}


- (void)createContentView
{

    if ([_theId isEqualToString:@"6"]) {
        self.flashV.fromStr = @"1";
    }else{
        self.recommendV.theId = _theId;
    }
    
    if ([_theId isEqualToString:@"-3"]) {
        [self judgeLoginStatus];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeLoginStatus) name:@"loginOrQuitSuccess" object:nil];
    }
    
//    [self.contentView addSubview:self.newsV];
}
-(void)judgeLoginStatus
{
    
    if ([UserInfo share].isLogin) {
        [self.notLoginV removeFromSuperview];
    }else{
        
        [self.contentView addSubview:self.notLoginV];
    }
}
- (UIView *)flashV
{
    if (!_flashV) {
        
        _flashV = [[HomeFlashV alloc] initWithFrame:self.bounds withFrom:@"1"];
        [self.contentView addSubview:_flashV];
    }
    return _flashV;
}

- (LoveStockListVC *)listVC
{
    if (!_listVC) {
        _listVC = [[LoveStockListVC alloc] init];
        _listVC.theId = _theId;
        _listVC.view.frame = self.bounds;
        _listVC.view.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_listVC.view];

    }
    return _listVC;
}


- (UIView *)recommendV
{
    
    
    if (!_recommendV) {
        _recommendV = [[HomeRecommendV alloc] initWithFrame:self.bounds withId:_theId];
        [self.contentView addSubview:_recommendV];
        
    }
    return _recommendV;
}


- (UIView *)notLoginV
{
    if (!_notLoginV) {
        _notLoginV =  [[[NSBundle mainBundle] loadNibNamed:@"NotLoginV" owner:nil options:nil] lastObject];
        _notLoginV.frame = self.bounds;
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _notLoginV;
    
}

@end
