//
//  CenterEnvironmentTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
#import "iCarousel.h"
@interface CenterEnvironmentTVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;

@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property(nonatomic,strong)MainCenterModel * centerModel;
    @property (weak, nonatomic) IBOutlet iCarousel *iCarouselV;
    
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

-(void)updateWithModel;
@end
