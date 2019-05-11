//
//  ZWCommentCell.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/27.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "ZWCommentCell.h"

@implementation ZWCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //
    [self setupUI];
}

- (void)setupUI {
    
}

- (void)setCommentDict:(NSDictionary *)commentDict{
    _commentDict = commentDict;
    self.commentLabel.text = commentDict[@"comment"];
    self.timeLabel.text = commentDict[@"created_at"];
    self.commentCountLabel.text = [commentDict[@"hits"] stringValue];
    //userInfo
    NSDictionary *userInfo = commentDict[@"userInfo"];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"image"]] placeholderImage:nil];
    self.nameLabel.text = userInfo[@"nickname"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickReportButton:(id)sender {
}
@end
