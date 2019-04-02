//
//  TheCompanyTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface TheCompanyTVCell : UITableViewCell

@property(nonatomic,strong)TheCompanyModel * coModel;
@property (weak, nonatomic) IBOutlet UILabel *urlLab;

-(void)updateWithModel;
@end
