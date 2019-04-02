//
//  CenterAdvertTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDAdvertTVCell.h"
#import "EditAdvertVC.h"
@implementation RDAdvertTVCell
{
    CALayer *_BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bannerICV.pagingEnabled = YES;
    self.pageC.pageIndicatorTintColor = RGBACOLOR(255, 255, 255, 0.5);
    self.pageC.currentPageIndicatorTintColor = RGBCOLOR(35, 122, 229);
    // Initialization code
}
-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
//    _BVLayer = [[CALayer alloc] init];
//    _BVLayer.position = _shadowBV.layer.position;
//    _BVLayer.frame = _shadowBV.frame;
//    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
//    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
//    _BVLayer.shadowOffset = CGSizeMake(2, 2);
//    _BVLayer.shadowOpacity = 0.3;
//    [self.contentView.layer addSublayer:_BVLayer];
//    [self.contentView bringSubviewToFront:_shadowBV];
    
    
}
- (IBAction)addBtnClick:(UIButton *)sender {
    EditAdvertVC * adVC = [[EditAdvertVC alloc]init];
    [self.viewContoller.navigationController pushViewController:adVC animated:YES];
    
}


-(void)updateWithModel
{
    self.pageC.numberOfPages = self.deModel.advertArr.count;

    self.bannerICV.bounces = NO;
    [self.bannerICV reloadData];
}
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  self.deModel.advertArr.count;
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //    CGSize size =self.frame.size;
    

        UIImageView * imageV = (UIImageView*)view;
        
        if (imageV == nil) {
            imageV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bannerICV.width, _bannerICV.size.height)];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        CenterAdvertModel * imgModel = self.self.deModel.advertArr[index];
        [imageV sd_setImageWithURL:IMG_URL(imgModel.ad_url)];
        return imageV;
    
    return nil;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了:%ld",index);
    CenterAdvertModel * imgModel = self.self.deModel.advertArr[index];
    BaseWebVC *webVC  = [[BaseWebVC alloc]init];
    webVC.urlStr = imgModel.ad_link;
    [self.viewContoller.navigationController pushViewController:webVC animated:YES];
    
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    if (carousel == _bannerICV) {
        return  _bannerICV.width;
    }else{
        return 0;
    }
    //    return self.iCarouselV.width;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            //            NSLog(@"value:%f",value);
            return value * 1.00;
        }
        case iCarouselOptionFadeMax:
        {
            if (_bannerICV.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
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
    if (carousel == _bannerICV) {
        if (self.pageC.currentPage != carousel.currentItemIndex) {
            self.pageC.currentPage = carousel.currentItemIndex;
        }
    }
    
    
}
@end
