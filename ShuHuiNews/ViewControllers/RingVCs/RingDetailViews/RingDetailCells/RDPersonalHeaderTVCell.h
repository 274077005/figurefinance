//
//  RDHeaderTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
@interface RDPersonalHeaderTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImgV;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgV;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property(nonatomic,strong) RingDetailModel * deModel;

@property(nonatomic,strong) RingUserModel * userModel;
    
- (void)updateWithModel;
@end
