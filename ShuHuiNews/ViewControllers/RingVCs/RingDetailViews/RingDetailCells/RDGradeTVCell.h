//
//  RDGradeTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
@interface RDGradeTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *thridLab;
@property (weak, nonatomic) IBOutlet UILabel *fourthLab;


@property(nonatomic,strong) RingDetailModel * deModel;

- (void)updateWithModel;
@end
