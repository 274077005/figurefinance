//
//  MainBellTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainBellTVCell.h"

@implementation MainBellTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateWithModel
{
    [self.headerImgV sd_setImageWithURL:_bellModel.img];
    self.titleLab.text = _bellModel.author;
    self.timeLab.text = _bellModel.updated_at;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    NSMutableAttributedString *str=  [[NSMutableAttributedString alloc] initWithData:[_bellModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSParagraphStyleAttributeName:paraStyle} documentAttributes:nil error:nil];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str.length)];
    self.contentLab.attributedText = str;
    
}
@end
