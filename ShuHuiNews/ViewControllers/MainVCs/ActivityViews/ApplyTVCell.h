//
//  applyTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/5.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface ApplyTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property(nonatomic,strong)ActivityModel * acModel;

-(void)updateWithModel;
@end
