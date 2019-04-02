//
//  HomeSpecialTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeSpecialTVCell.h"
#import "SpecialListVC.h"
@implementation HomeSpecialTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithModel
{
 
    [_bigImgV sd_setImageWithURL:_newsModel.imgurl];
    _titleLab.text = _newsModel.title;
    
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    
    SpecialListVC * listVC = [[SpecialListVC alloc]init];
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];
}

@end
