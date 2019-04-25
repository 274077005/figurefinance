//
//  BookTagHeaderV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookTagHeaderV.h"
#import "ChoiceListVC.h"
@implementation BookTagHeaderV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)moreBtnClick:(UIButton *)sender {
    
    ChoiceListVC * listVC = [[ChoiceListVC alloc]init];
    
    listVC.category_id = self.sectionModel.category_id;
//    listVC.category_id = @"3";
    listVC.titleStr= self.sectionModel.category_name;
    
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];
    
    
}

-(void)updateWithModel
{
    self.titleLab.text = self.sectionModel.category_name;
}
@end
