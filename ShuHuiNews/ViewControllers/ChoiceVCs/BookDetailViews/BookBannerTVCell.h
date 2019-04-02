//
//  BookBannerTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookBannerCVCell.h"
#import "BookDetailModel.h"
@interface BookBannerTVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *publishLab;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet iCarousel *bannerICV;
@property(nonatomic,strong)NSArray * dataArr;


@property(nonatomic,strong)BookDetailModel * detailModel;

-(void)updateWithModel;
@end
