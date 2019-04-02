//
//  TheRDRegulationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
@interface TheRDRegulationTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

-(void)updateWithModel;
@property(nonatomic,strong)DetailArrModel * arrModel;
@end
