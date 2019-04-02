//
//  HomeSpecialTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsModel.h"
@interface HomeSpecialTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property(nonatomic,strong)HomeNewsModel * newsModel;
- (void)updateWithModel;

@end
