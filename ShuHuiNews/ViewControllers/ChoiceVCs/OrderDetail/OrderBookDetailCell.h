//
//  OrderBookDetailCell.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/2.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderBookDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audioIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bookIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

@end

NS_ASSUME_NONNULL_END
