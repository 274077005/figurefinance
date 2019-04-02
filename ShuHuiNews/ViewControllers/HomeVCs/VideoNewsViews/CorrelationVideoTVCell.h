//
//  CorrelationVideoTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorrelationCVCell.h"
#import "VideoDetailModel.h"
#import "HQACVCell.h"
@interface CorrelationVideoTVCell : UITableViewCell<iCarouselDelegate,iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselV;

@property(nonatomic,strong)VideoDetailModel * detailModel;

@property(nonatomic,copy)void(^videoBlock)(NSString *);

- (void)updateWithModel;
@end
