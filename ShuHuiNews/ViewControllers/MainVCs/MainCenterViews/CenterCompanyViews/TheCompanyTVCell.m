//
//  TheCompanyTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheCompanyTVCell.h"
#import "ProvidePickerV.h"
@implementation TheCompanyTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel
{
    if ([_coModel.type isEqualToString:@"0"]) {
        self.urlLab.text = [NSString stringWithFormat:@"中文网址:%@",_coModel.company_url];
    }else{
        self.urlLab.text = [NSString stringWithFormat:@"英文网址:%@",_coModel.company_url];
    }
    
}

@end
