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
    self.contentLab.text = self.listModel.content;
    self.authorLabel.text = self.listModel.author;
}
@end
