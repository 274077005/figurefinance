//
//  HomeColumnTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeQATVCell.h"
#import "RingQAVC.h"
@implementation HomeQATVCell

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
    
    RingQAVC * QAListVC = [[RingQAVC alloc]init];
    [self.viewContoller.navigationController pushViewController:QAListVC animated:YES];
    
}

- (void)updateWithModel
{
    [self.iCarouselV reloadData];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _newsModel.question.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    
    HQACVCell * CellView = (HQACVCell*)view;
    if (CellView == nil) {
        CellView = [[[NSBundle mainBundle] loadNibNamed:@"HQACVCell" owner:nil options:nil] firstObject];
        NSInteger width = self.width/1.2;
        CellView.frame = CGRectMake(0, 0, width, _iCarouselV.height);
        CellView.layer.masksToBounds = YES;
        
    }
    HQListModel * qModel = _newsModel.question[index];

    CellView.moneyLab.text = [NSString stringWithFormat:@"￥%@",qModel.price];
    CellView.contentLab.text = [NSString stringWithFormat:@"%@",qModel.question];
    CellView.numberLab.text = [NSString stringWithFormat:@"%@回答",qModel.num];
    CellView.timeLab.text = [NSString stringWithFormat:@"%@·%@·%@",qModel.nickname,qModel.datetime,qModel.type_name];
    return CellView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    QADetailVC * detailVC = [[QADetailVC alloc]init];
    HQListModel * qModel = _newsModel.question[index];
    detailVC.QAId = qModel.theId;
    

    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    NSInteger width = self.width/1.2;
    return width;
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
