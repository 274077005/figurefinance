//
//  MainBellTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainBellModel.h"
@interface MainBellTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property(nonatomic,strong)MainBellModel * bellModel;

- (void)updateWithModel;
@end
