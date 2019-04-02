//
//  HomeFlashTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeFlashTVCell.h"

@implementation HomeFlashTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//- (void)updateWithModel
//{
//    if (_flashModel.isFirst) {
//        _timeLab.textColor = RGBCOLOR(14, 124, 244);
//        _ballTopV.backgroundColor = RGBCOLOR(14, 124, 244);
//        _ballV.backgroundColor = RGBCOLOR(14, 124, 244);
//    }else{
//        _timeLab.textColor = RGBCOLOR(217, 217, 217);
//        _ballTopV.backgroundColor = RGBCOLOR(217, 217, 217);
//        _ballV.backgroundColor = RGBCOLOR(217, 217, 217);
//    }
//    
//    
//    _timeLab.text = _flashModel.updatetime;
//
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineSpacing = 5;
//    NSMutableAttributedString *str=  [[NSMutableAttributedString alloc] initWithData:[_flashModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSParagraphStyleAttributeName:paraStyle} documentAttributes:nil error:nil];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str.length)];
//    _contentLab.attributedText = str;
//}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//- (IBAction)shareBtnClick:(UIButton *)sender {
//    
//    FlashShareV * shareV =  [[[NSBundle mainBundle] loadNibNamed:@"FlashShareV" owner:nil options:nil] lastObject];
//    shareV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [shareV updateWithContentStr:_flashModel.content];
//    
//    UIImage * shareImg = [GYToolKit snapshotSingleView:shareV.contentV];
//
//    
//
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    NSArray* imageArray = @[shareImg];
//    [shareParams SSDKSetupShareParamsByText:@"数汇资讯"
//                                     images:imageArray
//                                        url:nil
//                                      title:@"快讯"
//                                       type:SSDKContentTypeImage];
//    
//    [GYToolKit shareSDKToShare:shareParams];
//    
//}

@end
