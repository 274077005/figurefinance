//
//  FlashSharePreviewVC.h
//  HuiyouNet
//
//  Created by 耿一 on 2018/11/13.
//  Copyright © 2018 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FlashSharePreviewVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstHeight;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondHeight;
@property (weak, nonatomic) IBOutlet UIImageView *thridImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridHeight;


@property(nonatomic,strong)FlashModel * model;

@end

NS_ASSUME_NONNULL_END
