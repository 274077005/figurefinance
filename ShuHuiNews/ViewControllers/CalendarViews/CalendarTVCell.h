//
//  CalendarTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarRatingView.h"
#import "CalendarModel.h"
@interface CalendarTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *goDownImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *previousLab;
@property (weak, nonatomic) IBOutlet UILabel *consensusLab;
@property (weak, nonatomic) IBOutlet UILabel *actualLab;
@property (weak, nonatomic) IBOutlet CalendarRatingView *starV;


@property (strong,nonatomic)CalendarModel * caModel;

- (void)updateWithModel;
@end
