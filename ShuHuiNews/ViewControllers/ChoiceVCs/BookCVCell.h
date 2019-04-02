//
//  BookCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceModel.h"
@interface BookCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property(nonatomic,strong)ComListModel * listModel;

-(void)updateWithModel;
@end
