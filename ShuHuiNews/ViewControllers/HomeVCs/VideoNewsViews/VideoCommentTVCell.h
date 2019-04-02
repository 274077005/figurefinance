//
//  VideoCommentTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDetailModel.h"
@interface VideoCommentTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *praiseBV;

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImgV;

@property(nonatomic,strong)VCommentModel * commentModel;
-(void)updateWithModel;
@end
