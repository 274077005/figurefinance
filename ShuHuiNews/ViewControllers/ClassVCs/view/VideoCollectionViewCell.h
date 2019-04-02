//
//  VideoCollectionViewCell.h
//  video
//
//  Created by zzw on 2017/1/12.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"


@interface VideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLab;
@property (weak, nonatomic) IBOutlet UILabel *lookNumLab;


- (void)updateWith:(VideoModel *)m;
@end
