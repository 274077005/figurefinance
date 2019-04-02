//
//  HomeFlashTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"
#import "FlashShareV.h"
@interface HomeFlashTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *ballTopV;
@property (weak, nonatomic) IBOutlet UIView *ballBottomV;
@property (weak, nonatomic) IBOutlet UIView *ballV;




//
//@property(nonatomic,strong)FlashDetailModel * flashModel;
- (void)updateWithModel;


@end
