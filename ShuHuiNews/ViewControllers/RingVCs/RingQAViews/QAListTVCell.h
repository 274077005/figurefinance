//
//  QAListTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAListModel.h"
#import "HomeNewsModel.h"
@interface QAListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property(nonatomic,strong)QAListModel * listModel;

@property(nonatomic,strong)HomeNewsModel * newsModel;

//收藏里要用到
-(void)updateWithNewsModel;
- (void)updateWithModel;
@end
