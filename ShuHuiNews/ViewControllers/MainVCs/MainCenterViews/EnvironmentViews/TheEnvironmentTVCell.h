//
//  TheEnvironmentTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface TheEnvironmentTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property(nonatomic,strong)TheEnvironmentModel * enModel;
-(void)updateWithModel;

@end
