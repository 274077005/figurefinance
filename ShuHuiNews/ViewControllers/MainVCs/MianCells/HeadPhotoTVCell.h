//
//  HeadPhotoTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainRootModel.h"
#import "MainCollectVC.h"
@interface HeadPhotoTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *likeLab;
@property (weak, nonatomic) IBOutlet UIView *likeBV;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UIView *fansBV;
@property (weak, nonatomic) IBOutlet UILabel *collectLab;
@property (weak, nonatomic) IBOutlet UIView *collectBV;
@property (weak, nonatomic) IBOutlet UILabel *editLab;

@property(nonatomic,strong)MainRootModel * mainModel;
-(void)updateWithModel;
@end
