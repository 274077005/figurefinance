//
//  FloatContainerCell.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/13.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "FloatContainerCell.h"
#import "BookDetailMenuViewController.h"
#import "BookDetailAlikeViewController.h"
#import "BookDetailIntroViewController.h"

@interface FloatContainerCell ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) BookDetailIntroViewController *first;
@property (nonatomic,strong) BookDetailMenuViewController *second;
@property (nonatomic,strong) BookDetailAlikeViewController *three;

@end
@implementation FloatContainerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (UIView *sub in self.contentView.subviews ) {
            [sub removeFromSuperview];
        }
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}
- (void)setVC:(UIViewController *)VC
{
    _VC = VC;
    [self configScrollView];
}
- (void)configScrollView
{
    _first = [BookDetailIntroViewController new];
    _first.VC = _VC;
    _second = [BookDetailMenuViewController new];
    _second.VC = _VC;
    _three = [BookDetailAlikeViewController new];
    _three.VC = _VC;
    
    
    [self.scrollView addSubview:_first.view];
    [self.scrollView addSubview:_second.view];
    [self.scrollView addSubview:_three.view];
    CGFloat height = iphoneX?34:0;
    _first.view.frame=
    CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight-45-height);
    _second.view.frame=
    CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight-45-height);
    _three.view.frame=
    CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight-45-height);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isSelectIndex = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //为了横向滑动的时候，外层的tableview不动
    if (!self.isSelectIndex) {
        if (scrollView == self.scrollView) {
            if([self.delegate respondsToSelector:@selector(containerScrollViewDidScroll:)]){
                [self.delegate containerScrollViewDidScroll:scrollView];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if ([self.delegate respondsToSelector:@selector(containerScrollViewDidEndDecelerating:)]) {
            [self.delegate containerScrollViewDidEndDecelerating:self.scrollView];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Init Views
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight-45)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, _scrollView.frame.size.height);
    }
    return _scrollView;
}
- (void)setObjectCanScroll:(BOOL)objectCanScroll
{
    _objectCanScroll = objectCanScroll;
    self.first.vcCanScroll = objectCanScroll;
    self.second.vcCanScroll = objectCanScroll;
    self.three.vcCanScroll = objectCanScroll;
    
    if (!objectCanScroll) {
        [self.first.tableView setContentOffset:CGPointZero animated:NO];
        [self.second.tableView setContentOffset:CGPointZero animated:NO];
        [self.three.tableView setContentOffset:CGPointZero  animated:NO];
    }
}
@end
