//
//  RDGradeTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
@interface RDPersonalBasicTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *shadowBV;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;


@property(nonatomic,strong) RingDetailModel * deModel;

- (void)updateWithModel;
@end
