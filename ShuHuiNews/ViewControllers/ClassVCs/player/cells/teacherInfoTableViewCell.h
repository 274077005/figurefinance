//
//  teacherInfoTableViewCell.h
//  Treasure
//
//  Created by zzw on 2017/1/17.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
typedef void(^playAllInfo) (CGFloat);
@interface teacherInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titelLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLab;
@property (weak, nonatomic) IBOutlet UILabel *lookLab;
@property (weak, nonatomic) IBOutlet UIImageView *teacherImagV;
@property (weak, nonatomic) IBOutlet UILabel *teacherInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *teachNameLab;
@property (weak, nonatomic) IBOutlet UIButton *lookAllBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherInfoHeight;
@property (nonatomic, copy) NSString * info;
@property (copy, nonatomic) playAllInfo play;
@property (assign,nonatomic) CGFloat height;


- (void)updateWith:(VideoModel*)m;
@end
