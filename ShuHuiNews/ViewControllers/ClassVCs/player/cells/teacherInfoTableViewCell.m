//
//  teacherInfoTableViewCell.m
//  Treasure
//
//  Created by zzw on 2017/1/17.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "teacherInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
@implementation teacherInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.teacherImagV, 35);
    
    // Initialization code
}
- (void)updateWith:(VideoModel*)m{
 

    self.teacherInfoLab.attributedText =[self stringWithstr:m.teacher_intr];
    
    self.teacherNameLab.text = [NSString stringWithFormat:@"讲师:%@",m.teacher_name];
    self.teachNameLab.text = m.teacher_name;
    [self.teacherImagV sd_setImageWithURL:m.teacher_img];
    self.lookLab.text = m.play_times;
    self.titelLab.text = m.title;

    self.info = m.teacher_intr;
   
}
-(void)layoutSubviews{
 
     self.teacherInfoHeight.constant = self.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(UIButton *)sender {
    
  
    if (!self.lookAllBtn.selected) {
        CGFloat f = [self getSpaceLabelHeightwithStr:self.info];
        
        self.play(f);
    }else{
    
        self.play(70);
    }
    
}



-(NSAttributedString *)stringWithstr:(NSString* )str {
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@0.5f,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriStr addAttributes:attributes range:NSMakeRange(0, str.length)];
    return attriStr;
}




/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithStr:(NSString*)str {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = 7;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.frame.size.width-115,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
@end
