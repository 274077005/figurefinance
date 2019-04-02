//
//  HomeColumnTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsModel.h"
#import "HQACVCell.h"
@interface HomeQATVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet iCarousel *iCarouselV;


@property(nonatomic,strong)HomeNewsModel * newsModel;
- (void)updateWithModel;

@end
