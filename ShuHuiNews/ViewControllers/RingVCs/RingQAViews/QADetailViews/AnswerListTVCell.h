//
//  AnswerListTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAListModel.h"

@interface AnswerListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property(nonatomic,strong)AnswersModel * aModel;




-(void)updateWithModel;
@end
