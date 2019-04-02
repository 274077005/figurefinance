//
//  CenterHeaderTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/20.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
#import "PhotoPicker.h"
@interface CenterHeaderTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgV;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (weak, nonatomic) IBOutlet UIView *shadowBV;

@property(nonatomic,strong)MainCenterModel * centerModel;

-(void)updateWithModel;
@end
