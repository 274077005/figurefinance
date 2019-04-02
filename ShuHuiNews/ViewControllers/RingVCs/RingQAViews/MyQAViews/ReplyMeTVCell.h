//
//  ReplyMeTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyMeModel.h"
@interface ReplyMeTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *replyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *questionLab;
@property (weak, nonatomic) IBOutlet UILabel *replyTypeLab;

@property(nonatomic,strong)ReplyMeModel *model;

@property(nonatomic,copy)NSString * replyType;
- (void)updateWithModel;

@end
