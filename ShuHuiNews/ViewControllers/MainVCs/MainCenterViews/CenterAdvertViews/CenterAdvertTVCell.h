//
//  CenterAdvertTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MainCenterModel.h"
@interface CenterAdvertTVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet iCarousel *bannerICV;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;

@property(nonatomic,strong)MainCenterModel * centerModel;
-(void)updateWithModel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
