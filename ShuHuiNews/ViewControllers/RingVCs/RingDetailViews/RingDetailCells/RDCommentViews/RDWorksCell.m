//
//  RDWorksCell.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "RDWorksCell.h"

@implementation RDWorksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWorksModel:(HomeAuthorModel *)worksModel{
    NSLog(@"...");
    [self.booksImageView sd_setImageWithURL:worksModel.img];
    self.namelabel.text = worksModel.name;
    self.priceLabel.text = @"22.0金豆";
    self.tapLabel.text = [NSString stringWithFormat:@"%ld",worksModel.click_num];
}

@end
