//
//  TheRegulationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface TheRegulationTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property(nonatomic,strong)CenterRegulationModel * regulationModel;
-(void)updateWithModel;

@end
