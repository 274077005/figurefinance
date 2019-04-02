//
//  HomeBannerV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomepageControl.h"
#import "HomeBannerICVCell.h"
#import "ChoiceModel.h"
#import "CommentWebVC.h"
#import "HomeSearchVC.h"
#import "BookDetailVC.h"
#import "ChoiceListVC.h"
@interface ChoiceBannerV : UIView<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet iCarousel *bannerICV;

@property (weak, nonatomic) IBOutlet HomepageControl *pageC;

@property(nonatomic,strong)NSArray * dataArr;

@property(nonatomic,strong)ChoiceBookModel * sectionModel;

- (void)setUpBannerV;
@end
