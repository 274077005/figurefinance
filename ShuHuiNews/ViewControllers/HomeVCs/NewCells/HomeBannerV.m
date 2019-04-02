//
//  HomeBannerV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeBannerV.h"

@implementation HomeBannerV
{
    NSTimer * _scrollTimer;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

//        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createScrollViewTimer];
    self.bannerICV.backgroundColor = [UIColor whiteColor];
    //在这选风格
    self.bannerICV.type = iCarouselTypeLinear;
    self.bannerICV.dataSource = self;
    self.bannerICV.delegate = self;
    self.bannerICV.pagingEnabled = YES;
    self.pageC.currentPage = 0;
}

//创建定时器
- (void)createScrollViewTimer
{
    if (!_scrollTimer) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeScrolviewOffset) userInfo:nil repeats:YES];
    }
}
//利用定时器自动滚动头视图
-(void)changeScrolviewOffset{
    [_bannerICV scrollByNumberOfItems:1 duration:1];
    
}

- (void)setUpBannerV{
    

    self.pageC.numberOfPages = _dataArr.count;
    [self.bannerICV reloadData];
    
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    
    return _dataArr.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    CGSize size =self.frame.size;
    HomeBannerICVCell * ChView = (HomeBannerICVCell*)view;
    if (ChView == nil) {
        ChView = [[[NSBundle mainBundle] loadNibNamed:@"HomeBannerICVCell" owner:nil options:nil] firstObject];
        ChView.frame = CGRectMake(0, 0, size.width/1.1, self.bannerICV.height);
        ChView.layer.masksToBounds = YES;
        //设置圆角半径
        ChView.layer.cornerRadius = 8;
        ChView.layer.borderWidth = 0.5;
        ChView.layer.borderColor = [[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor];
    }
    HomeBannerModel * model = [HomeBannerModel mj_objectWithKeyValues:_dataArr[index]];
//    NSLog(@"%@",model.image_url);
//    ChView.imgV.backgroundColor = randomColor;
    [ChView.imgV sd_setImageWithURL:model.image_url];
    ChView.titleLab.text = model.title;

    return ChView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    HomeBannerModel * model = [HomeBannerModel mj_objectWithKeyValues:_dataArr[index]];
    
    if (model.news_type == 22) {
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        webVC.urlStr = model.href_url;
        [self.viewContoller.navigationController pushViewController:webVC animated:YES];
    }else{
        CommentWebVC * webVC = [[CommentWebVC alloc]init];
        if ([UserInfo share].isLogin) {
            webVC.urlStr = [NSString stringWithFormat:@"%@&uid=%@",model.href_url,[UserInfo share].uId];
        }else{
            webVC.urlStr = model.href_url;
        }
        [self.viewContoller.navigationController pushViewController:webVC animated:YES];
    }


}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return self.width/1.1;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            //            NSLog(@"value:%f",value);
            return value * 1.03;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.bannerICV.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        {
            return NO;
        }
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    //    NSLog(@"FFF:%ld",carousel.currentItemIndex);
    if (self.pageC.currentPage != carousel.currentItemIndex) {
        self.pageC.currentPage = carousel.currentItemIndex;
    }
    
}

@end
