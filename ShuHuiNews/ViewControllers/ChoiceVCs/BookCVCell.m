//
//  BookCVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookCVCell.h"

@implementation BookCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateWithModel
{
    
    [self.coverImgV sd_setImageWithURL:self.listModel.img];
    self.titleLab.text = self.listModel.name;
//    self.contentLab.text = self.listModel.content;
//    self.authorLabel.text = self.listModel.author;

    [self.userAvatar sd_setImageWithURL:self.userInfo[@"image"]];
    self.authorLabel.text = self.userInfo[@"nickname"];
    //取最后一个的价格
    NSDictionary *dict = self.extendInfo.lastObject;
    self.priceLabel.text = [NSString stringWithFormat:@"%@金豆",dict[@"price"]];
}
@end
