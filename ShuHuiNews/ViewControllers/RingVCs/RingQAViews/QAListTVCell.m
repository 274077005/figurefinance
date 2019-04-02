//
//  QAListTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "QAListTVCell.h"

@implementation QAListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateWithModel
{
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",_listModel.price];
    self.contentLab.text = [NSString stringWithFormat:@"%@",_listModel.question];
    self.numberLab.text = [NSString stringWithFormat:@"%@回答",_listModel.answers_count];
    self.timeLab.text = [NSString stringWithFormat:@"%@·%@·%@",_listModel.user.nickname,_listModel.created_at,_listModel.type.name];

}
-(void)updateWithNewsModel
{
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",_newsModel.price];
    self.contentLab.text = [NSString stringWithFormat:@"%@",_newsModel.title];
    self.numberLab.text = [NSString stringWithFormat:@"%@回答",_newsModel.answer_count];
    self.timeLab.text = [NSString stringWithFormat:@"%@·%@·%@",_newsModel.issue,_newsModel.updatetime,_newsModel.type_name];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
