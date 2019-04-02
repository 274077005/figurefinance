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
#import "HomeNewsModel.h"
#import "CommentWebVC.h"

@interface HomeBannerV : UIView<iCarouselDelegate,iCarouselDataSource>


@property (weak, nonatomic) IBOutlet iCarousel *bannerICV;

@property (weak, nonatomic) IBOutlet HomepageControl *pageC;

@property(nonatomic,strong)NSArray * dataArr;

- (void)setUpBannerV;
@end
