//
//  HomeColumnTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeColumnTVCell.h"
#import "ColumnListVC.h"
@implementation HomeColumnTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iCarouselV.backgroundColor = [UIColor whiteColor];
    //在这选风格
    self.iCarouselV.type = iCarouselTypeLinear;
    self.iCarouselV.dataSource = self;
    self.iCarouselV.delegate = self;
    self.iCarouselV.pagingEnabled = NO;
    self.iCarouselV.bounces = NO;
    // Initialization code
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    
    ColumnListVC * columnVC = [[ColumnListVC alloc]init];
    [self.viewContoller.navigationController pushViewController:columnVC animated:YES];
    
}

- (void)updateWithModel
{
    [self.iCarouselV reloadData];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    
    return _newsModel.columnist.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    NSLog(@"%f",_iCarouselV.height);
    
    HColumnICVCell * CellView = (HColumnICVCell*)view;
    if (CellView == nil) {
        CellView = [[[NSBundle mainBundle] loadNibNamed:@"HColumnICVCell" owner:nil options:nil] firstObject];
        CellView.frame = CGRectMake(0, 0, _iCarouselV.width/1.3, _iCarouselV.height);
        CellView.layer.masksToBounds = YES;
        
        
        
    }
    HomeNewsModel * coModel = _newsModel.columnist[index];
    [CellView.headerImgV sd_setImageWithURL:coModel.head_portrait placeholderImage:IMG_Name(@"headerHold")];
    CellView.titleLab.text = [NSString stringWithFormat:@"%@·%@",coModel.updatetime,coModel.type_name];
    CellView.contentLab.text = coModel.title;
    return CellView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    HomeNewsModel * coModel = _newsModel.columnist[index];
    CommentWebVC * webVC = [[CommentWebVC alloc]init];
    if ([UserInfo share].isLogin) {
        webVC.urlStr = [NSString stringWithFormat:@"%@&uid=%@",coModel.href_url,[UserInfo share].uId];
    }else{
        webVC.urlStr = coModel.href_url;
    }
    
    [self.viewContoller.navigationController pushViewController:webVC animated:YES];
    
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    return self.width/1.3;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
