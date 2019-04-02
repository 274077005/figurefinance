//
//  moreVideoTableViewCell.m
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "moreVideoTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation moreVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateWith:(VideoModel*)m{
   
    [self.tImgV sd_setImageWithURL:m.backgroud_img placeholderImage:[UIImage imageNamed:@"Video_BSmall"]];
    self.timeLba.text = m.video_time_length;
    self.titleLab.text = m.title;
    self.lookLab.text = m.play_times;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
