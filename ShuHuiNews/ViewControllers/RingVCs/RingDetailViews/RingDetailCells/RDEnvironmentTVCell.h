//
//  CenterEnvironmentTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
#import "iCarousel.h"
@interface RDEnvironmentTVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;

@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property(nonatomic,strong)RingDetailModel * centerModel;
    @property (weak, nonatomic) IBOutlet iCarousel *iCarouselV;
    


-(void)updateWithModel;
@end
