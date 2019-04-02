//
//  HomeImgsTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsModel.h"
@interface HomeImgsTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;


@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *topLab;

@property(nonatomic,strong)HomeNewsModel * newsModel;
- (void)updateWithModel;
@end
