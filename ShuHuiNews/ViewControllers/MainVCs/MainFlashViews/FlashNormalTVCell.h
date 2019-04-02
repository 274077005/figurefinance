//
//  FlashNormalTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"
#import "FlashShareV.h"
#import "FlashSharePreviewVC.h"
@interface FlashNormalTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *shadowBV;

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;

@property (weak, nonatomic) IBOutlet UIImageView *praiseImgV;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;
@property (weak, nonatomic) IBOutlet UIView *praiseBV;

@property (weak, nonatomic) IBOutlet UIView *shareBV;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;

-(void)updateWithModel;
@property(nonatomic,strong)FlashModel * flashModel;

@end
