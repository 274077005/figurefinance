//
//  CalendarTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CalendarTVCell.h"

@implementation CalendarTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _statusLab.layer.borderWidth = 0.5;
    _starV.ratingType = INTEGER_TYPE;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)updateWithModel
{
    self.timeLab.text = _caModel.time_show;
    
    _headerImgV.image = IMG_Name(_caModel.country);
    if ([_caModel.status_name isEqualToString:@"未公布"]) {
        _statusLab.text = @"未公布";
        _statusLab.textColor = RGBCOLOR(204, 204, 204);
        _statusLab.layer.borderColor = RGBCOLOR(204, 204, 204).CGColor;
    }else{
        _statusLab.text = @"已公布";
        _statusLab.textColor = RGBCOLOR(31, 31, 31);
        _statusLab.layer.borderColor = RGBCOLOR(31, 31, 31).CGColor;
    }
    _goDownImgV.hidden = NO;
    if ([_caModel.status_name isEqualToString:@"利多"]) {
        _goDownImgV.image = IMG_Name(@"goUp");
    }else if ([_caModel.status_name isEqualToString:@"利空"]){
        _goDownImgV.image = IMG_Name(@"goDown");
    }else{
        _goDownImgV.hidden = YES;
    }
    if ([_caModel.title containsString:_caModel.unit]) {
        _previousLab.text = [NSString stringWithFormat:@"前值:%@",_caModel.previous];
        _consensusLab.text = [NSString stringWithFormat:@"预测值:%@",_caModel.consensus];
        _actualLab.text = [NSString stringWithFormat:@"公布值:%@",_caModel.actual];
    }else{
        _previousLab.text = [NSString stringWithFormat:@"前值:%@%@",_caModel.previous,_caModel.unit];
        _consensusLab.text = [NSString stringWithFormat:@"预测值:%@%@",_caModel.consensus,_caModel.unit];
        _actualLab.text = [NSString stringWithFormat:@"公布值:%@%@",_caModel.actual,_caModel.unit];
    }
    if (_caModel.previous.length <1) {
        _previousLab.text = @"前值:--";
    }
    if (_caModel.consensus.length <1) {
        _consensusLab.text = @"预测值:--";
    }
    if (_caModel.actual.length <1) {
        _actualLab.text = @"公布值:--";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    NSMutableAttributedString *str=  [[NSMutableAttributedString alloc] initWithData:[_caModel.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSParagraphStyleAttributeName:paraStyle} documentAttributes:nil error:nil];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length)];
    
    if ([_caModel.star integerValue]>=3) {
        _starV.threeStar = YES;
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(35, 122, 229) range:NSMakeRange(0, str.length)];
    }else{
        _starV.threeStar = NO;
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(33, 33, 33) range:NSMakeRange(0, str.length)];
    }
    
    
    _titleLab.attributedText = str;
    
    [_starV setUpContentView];
    _starV.score = [_caModel.star integerValue];
    
}
@end
