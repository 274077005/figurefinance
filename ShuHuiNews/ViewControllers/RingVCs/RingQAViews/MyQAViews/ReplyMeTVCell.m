//
//  ReplyMeTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ReplyMeTVCell.h"

@implementation ReplyMeTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithModel
{
    if ([_replyType isEqualToString:@"commentOther"]) {
        _replyTypeLab.text = @"评论:";
    }
    [self.headerBtn sd_setImageWithURL:_model.evaler.image forState:UIControlStateNormal placeholderImage:IMG_Name(@"headerHold")];
    NSString * nameStr;
    if (_model.evaler.nickname.length > 0) {
        nameStr = _model.evaler.nickname;
    }else{
        nameStr = _model.delivery.user.nickname;
    }
    self.nameLab.text = nameStr;
    self.timeLab.text = _model.created_at;
    self.questionLab.text = _model.delivery.question;
    self.replyLab.text = _model.eval;
}

@end
