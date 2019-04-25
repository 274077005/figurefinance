//
//  BookCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceModel.h"
@interface BookCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audioIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bookIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;


@property(nonatomic,strong)ComListModel * listModel;
@property(nonatomic,strong)ExtendModel * extendModel;

@property(nonatomic,strong)NSArray *typeArray;

@property(nonatomic,strong)NSDictionary *userInfo;
@property(strong, nonatomic) NSArray *extendInfo;

-(void)updateWithModel;
@end
