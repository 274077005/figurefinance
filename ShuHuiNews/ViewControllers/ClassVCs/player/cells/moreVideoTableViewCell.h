//
//  moreVideoTableViewCell.h
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface moreVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLba;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *lookLab;
- (void)updateWith:(VideoModel*)m;
@end
