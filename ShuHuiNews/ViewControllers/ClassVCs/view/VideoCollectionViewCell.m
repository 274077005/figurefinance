//
//  VideoCollectionViewCell.m
//  video
//
//  Created by zzw on 2017/1/12.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation VideoCollectionViewCell
-(void)updateWith:(VideoModel *)m{

    [self.videoImg sd_setImageWithURL:m.backgroud_img placeholderImage:[UIImage imageNamed:@"Video_big"]];
    self.titleLab.text = m.title;
    self.teacherNameLab.text = [NSString stringWithFormat:@"讲师: %@",m.teacher_name];
    self.lookNumLab.text = m.play_times;
  
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (IBAction)playerClickBtn:(UIButton *)sender {
   
}

@end
