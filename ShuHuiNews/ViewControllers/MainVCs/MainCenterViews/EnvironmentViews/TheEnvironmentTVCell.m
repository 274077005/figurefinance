//
//  TheEnvironmentTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheEnvironmentTVCell.h"

@implementation TheEnvironmentTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel
{
    self.nameLab.text = _enModel.name;
    self.contentLab.text = _enModel.content;
}

@end
