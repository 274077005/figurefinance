//
//  FansTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FansTVCell.h"

@implementation FansTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.controllBtn.layer.borderWidth = 1.0;
    self.controllBtn.layer.borderColor = RGBCOLOR(14, 124, 244).CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
