//
//  BookTagHeaderV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceModel.h"
@interface BookTagHeaderV : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property(nonatomic,strong)ChoiceBookModel * sectionModel;

-(void)updateWithModel;
@end
