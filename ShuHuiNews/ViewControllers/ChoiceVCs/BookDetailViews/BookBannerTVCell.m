//
//  BookBannerTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookBannerTVCell.h"

@implementation BookBannerTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bannerICV.backgroundColor = RGBCOLOR(250, 250, 251);
    //在这选风格
//    self.bannerICV.layer.masksToBounds = YES;
    self.bannerICV.type = iCarouselTypeCustom;
    self.bannerICV.dataSource = self;
    self.bannerICV.delegate = self;
    self.bannerICV.pagingEnabled = YES;
    // Initialization code
}
-(void)updateWithModel
{
    self.nameLab.text = _detailModel.name;
    self.publishLab.text = _detailModel.publish;
    self.authorLab.text = [NSString stringWithFormat:@"作者:%@",_detailModel.author];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",_detailModel.price];
    [self.bannerICV reloadData];
}
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return _detailModel.img_info.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    BookBannerCVCell * ChView = (BookBannerCVCell*)view;
    
    if (ChView == nil) {
        ChView = [[[NSBundle mainBundle] loadNibNamed:@"BookBannerCVCell" owner:nil options:nil] firstObject];
        ChView.frame = CGRectMake(0, 0, self.bannerICV.width*0.5, self.bannerICV.height);

    }
    BookBannerModel * imgModel = _detailModel.img_info[0];
    [ChView.coverImgV sd_setImageWithURL:imgModel.img_url];
    return ChView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
//    ChoiceBannerModel * model = [ChoiceBannerModel mj_objectWithKeyValues:_dataArr[index]];
//    ChoiceDetailVC * detailVC = [[ChoiceDetailVC alloc]init];
//    //    detailVC.choiceId = model.news_id;
//    //    detailVC.titleStr = model.course_name;
//    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return self.bannerICV.width*0.5;
}
-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6666f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.bannerICV.itemWidth * 1.3, 0.0, 0.0);
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
            return value * 1.0;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.bannerICV.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 1.0;
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


@end
