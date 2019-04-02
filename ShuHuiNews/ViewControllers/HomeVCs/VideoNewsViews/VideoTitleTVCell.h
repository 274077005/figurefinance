//
//  VideoTitleTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDetailModel.h"
@interface VideoTitleTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tagFLab;
@property (weak, nonatomic) IBOutlet UILabel *tagSLab;
@property (weak, nonatomic) IBOutlet UILabel *tagTLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *contentBV;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;

@property(nonatomic,strong)UITableView * tableView;

@property(strong,nonatomic)VNewsModel * titleModel;
-(void)updateWithModel;
@end
