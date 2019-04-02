//
//  AnswerListTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AnswerListTVCell.h"

@implementation AnswerListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateWithModel
{
    [self.headerBtn sd_setImageWithURL:_aModel.evaler.image forState:UIControlStateNormal placeholderImage:IMG_Name(@"headerHold")];
    self.nameLab.text = _aModel.evaler.nickname;
    self.timeLab.text = _aModel.created_at;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_aModel.eval];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_aModel.eval length])];
    self.contentLab.attributedText = attributedString;
    
    
    
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@",_aModel.num] forState:UIControlStateNormal];
    if ([_aModel.isParise isEqualToString:@"1"]) {
        [self.praiseBtn setImage:IMG_Name(@"isPraise") forState:UIControlStateNormal];
        [self.praiseBtn setTitleColor:RGBCOLOR(14, 124, 244) forState:UIControlStateNormal];
        
    }else{
        [self.praiseBtn setImage:IMG_Name(@"notPraise") forState:UIControlStateNormal];
        [self.praiseBtn setTitleColor:RGBCOLOR(105, 105, 105) forState:UIControlStateNormal];
    }
    
}
- (IBAction)headerBtnClick:(UIButton *)sender {
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = _aModel.eval_id;
    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    
}
- (IBAction)praiseBtnClick:(UIButton *)sender {
    
    
    if ([_aModel.isParise isEqualToString:@"1"]) {
        _aModel.isParise = @"0";
        NSInteger priseCount = [_aModel.num integerValue];
        priseCount--;
        _aModel.num = [NSString stringWithFormat:@"%ld",priseCount];
    }else{
        _aModel.isParise = @"1";
        NSInteger priseCount = [_aModel.num integerValue];
        priseCount++;
        _aModel.num = [NSString stringWithFormat:@"%ld",priseCount];
    }
    [self updateWithModel];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_aModel.theId forKey:@"answer_id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JQADoPraise Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
