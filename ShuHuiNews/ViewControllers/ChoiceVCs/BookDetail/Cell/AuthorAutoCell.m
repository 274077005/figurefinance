//
//  AuthorAutoCell.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/19.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "AuthorAutoCell.h"

@implementation AuthorAutoCell
{
    UILabel *_contentLb;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _contentLb = [UILabel new];
        [self.contentView addSubview:_contentLb];
        _contentLb.textColor = RGBCOLOR(30, 30, 30);
        _contentLb.font = kFont_Lable_12;
        
        [_contentLb whc_LeftSpace:15];
        [_contentLb whc_TopSpace:0];
        [_contentLb whc_RightSpace:15];
        [_contentLb whc_AutoHeight];
        self.whc_CellBottomOffset = 10;
        self.whc_CellBottomView = _contentLb;
    }
    return self;
}
- (void)setContent:(NSString *)content
{
    _contentLb.text = content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
