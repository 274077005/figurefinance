//
//  MyQAVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MyQCommentVC.h"

@interface MyQCommentVC ()
{
    UIButton * _leftBtn;
    UIButton * _rightBtn;
    UIView * _lineV;
}

@end

@implementation MyQCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTitleView];
    [self createScrollView];

    
    // Do any additional setup after loading the view.
}

- (void)createScrollView
{
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-TopHeight)];
    _scrollV.pagingEnabled = YES;
    _scrollV.delegate = self;
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollV];
    _replyMeV = [[ReplyMeV alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)];
    [_scrollV addSubview:_replyMeV];
    _commentOtherV = [[ReplyMeV alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)];
    _commentOtherV.replyType = @"commentOther";
    [_scrollV addSubview:_commentOtherV];
    _scrollV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - TopHeight);
    
    
}
-(void)createTitleView
{
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, NavBarHeight)];

    self.navigationItem.titleView = titleV;
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 70, 25);
    _leftBtn.center = CGPointMake(_leftBtn.width/2, NavBarHeight/2);
    [_leftBtn setTitle:@"回复我的" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:RGBCOLOR(14, 14, 14) forState:UIControlStateSelected];
    [_leftBtn setTitleColor:RGBCOLOR(171, 171, 171) forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleV addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.selected = YES;
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 70, 25);
    _rightBtn.center = CGPointMake(titleV.width - _leftBtn.width/2, NavBarHeight/2);
    [_rightBtn setTitle:@"我发出的" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:RGBCOLOR(14, 14, 14) forState:UIControlStateSelected];
    [_rightBtn setTitleColor:RGBCOLOR(171, 171, 171) forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleV addSubview:_rightBtn];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
     _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 2)];
    _lineV.backgroundColor = RGBCOLOR(31,31,31);
    _lineV.center = CGPointMake(_leftBtn.center.x, NavBarHeight - 5);
    [titleV addSubview:_lineV];
    
}
- (void)leftBtnClick
{
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    [_scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _lineV.center = CGPointMake(_leftBtn.center.x, NavBarHeight - 5);
        
    }];
    
}
- (void)rightBtnClick
{
    
    _rightBtn.selected = YES;
    _leftBtn.selected = NO;
    [_scrollV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        
        _lineV.center = CGPointMake(_rightBtn.center.x, NavBarHeight - 5);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scrollV.contentOffset.x / SCREEN_WIDTH;
    NSLog(@"%ld",index);
    if (index == 1) {
        [self rightBtnClick];
    }else{
        [self leftBtnClick];
    }
//
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
