//
//  CenterCompanyTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface CenterPersonalBasicTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgV;



@property(nonatomic,strong)MainCenterModel * centerModel;
-(void)updateWithModel;

@end
