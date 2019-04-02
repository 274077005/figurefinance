//
//  CorrelationVideoTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CorrelationVideoTVCell.h"

@implementation CorrelationVideoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iCarouselV.backgroundColor = [UIColor whiteColor];
    //在这选风格
    self.iCarouselV.type = iCarouselTypeLinear;
    self.iCarouselV.dataSource = self;
    self.iCarouselV.delegate = self;
    self.iCarouselV.pagingEnabled = NO;
    self.iCarouselV.bounces = NO;
    self.iCarouselV.viewpointOffset = CGSizeMake(SCREEN_WIDTH * 0.274 - 15, 0);
    NSLog(@"point:%@",NSStringFromCGSize(self.iCarouselV.viewpointOffset));
    
    // Initialization code
}

- (void)updateWithModel
{
    [self.iCarouselV reloadData];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _detailModel.correlation.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSLog(@"%f",_iCarouselV.height);
     NSLog(@"point:%@",NSStringFromCGSize(self.iCarouselV.viewpointOffset));
    
    CorrelationCVCell * CellView = (CorrelationCVCell*)view;
    if (CellView == nil) {
        CellView = [[[NSBundle mainBundle] loadNibNamed:@"CorrelationCVCell" owner:nil options:nil] firstObject];
        CellView.frame = CGRectMake(0, 0, _iCarouselV.width/2.2, _iCarouselV.height);
        NSLog(@"%f",_iCarouselV.width);
        CellView.layer.masksToBounds = YES;
        
    }
    VCorrelationModel * coModel = _detailModel.correlation[index];
    [CellView.imageV sd_setImageWithURL:IMG_URL(coModel.imgurl)];
    CellView.titleLab.text = coModel.title;
    
    return CellView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    VCorrelationModel * coModel = _detailModel.correlation[index];
    self.videoBlock(coModel.href_url);
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return self.width/2.2;
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
            return value * 1.0;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.iCarouselV.type == iCarouselTypeCustom)
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

@end
