//
//  CenterRelationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"

@interface CenterRelationTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *weChatLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;

@property(nonatomic,strong)MainCenterModel * centerModel;

-(void)updateWithModel;
@end
