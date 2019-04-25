//
//  HomeBannerV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChoiceBannerV.h"

@implementation ChoiceBannerV
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

- (IBAction)moreBtnClick:(UIButton *)sender {
    
    ChoiceListVC * listVC = [[ChoiceListVC alloc]init];
    
    listVC.category_id = self.sectionModel.category_id;
    listVC.titleStr= self.sectionModel.category_name;
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topHeight.constant = StatusBarHeight;
    [self createScrollViewTimer];
    self.bannerICV.backgroundColor = [UIColor whiteColor];
    //在这选风格
    self.bannerICV.layer.masksToBounds = YES;
    self.bannerICV.type = iCarouselTypeRotary;
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
    if (_dataArr.count == 1) {
        [_scrollTimer setFireDate:[NSDate distantFuture]];
    }else{
        [_scrollTimer setFireDate:[NSDate distantPast]];
    }
//    if ([UserInfo share].isLogin) {
//        _nameLab.text = [NSString stringWithFormat:@"Hi,%@!",[UserInfo share].nickName];
//    }else{
//        _nameLab.text = @"Hi,你好~";
//    }
//    
}


#pragma mark iCarousel methods//轮播图

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //count<6
    if(_dataArr.count<6){
        return _dataArr.count;
    }else{
        return 5;
    }
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    HomeBannerICVCell * ChView = (HomeBannerICVCell*)view;
    
    if (ChView == nil) {
        ChView = [[[NSBundle mainBundle] loadNibNamed:@"HomeBannerICVCell" owner:nil options:nil] firstObject];
        ChView.frame = CGRectMake(0, 0, self.bannerICV.width/1, self.bannerICV.height);
        ChView.layer.masksToBounds = YES;
        //设置圆角半径
        ChView.layer.cornerRadius = 8;
        ChView.layer.borderWidth = 0.5;
        ChView.layer.borderColor = [[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor];
    }
    ChoiceBannerModel * model = [ChoiceBannerModel mj_objectWithKeyValues:_dataArr[index]];
//    NSLog(@"%@",model.image_url);
//    ChView.imgV.backgroundColor = randomColor;
    ChView.imgV.backgroundColor = [UIColor whiteColor];
    ChView.titleLab.text = model.title;
    NSLog(@"%@",model.title);
    [ChView.imgV sd_setImageWithURL:model.banner];
    //图片自适应
    ChView.imgV.contentMode = UIViewContentModeScaleAspectFit;
//    ChView.titleLab.hidden = YES;


    return ChView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    ChoiceBannerModel * model = [ChoiceBannerModel mj_objectWithKeyValues:_dataArr[index]];
    BookDetailVC * detailVC = [[BookDetailVC alloc]init];
    detailVC.bookId = model.book_id;
    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];

}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return self.bannerICV.width/1;
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
            return value * 1;
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
