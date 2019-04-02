//
//  FlashShareV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/29.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FlashShareV.h"

@implementation FlashShareV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    
    NSLog(@"flashView Dealloc");
    
}
-(void)updateWithContentStr:(FlashModel *)model
{

    self.titleLab.text = model.title;
    NSString * contentStr = model.content;
    
    CGFloat labelH = [GYToolKit AttribLHWithSpace:5 size:16 width:SCREEN_WIDTH - 60 str:contentStr];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    _contentLab.attributedText = attributedString;

    CGFloat contentH = labelH + 220;
    if (contentH < 330) {
        contentH = 330;
    }
    
    self.contentHeight.constant = contentH;
    [self.contentV layoutIfNeeded];

}

@end
