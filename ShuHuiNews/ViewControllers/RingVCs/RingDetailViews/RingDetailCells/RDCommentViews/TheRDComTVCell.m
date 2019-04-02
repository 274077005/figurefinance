//
//  VideoCommentTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheRDComTVCell.h"

@implementation TheRDComTVCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    UITapGestureRecognizer * praiseTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseBVClick)];
    [self.praiseBV addGestureRecognizer: praiseTGR];
    // Initialization code
}
- (void)praiseBVClick
{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:@"3" forKey:@"data_type"];
    [bodyDic setObject:_commentModel.theId forKey:@"comment_id"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    if ([_commentModel.is_praise isEqualToString:@"1"]) {
        [bodyDic setObject:@"2" forKey:@"is_praise"];
    }else{
        [bodyDic setObject:@"1" forKey:@"is_praise"];
    }
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JCompanyCommentPraise Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            NSInteger praiseNum = [_commentModel.hits integerValue];
            if ([_commentModel.is_praise isEqualToString:@"1"]) {
                _commentModel.is_praise = @"2";
                praiseNum--;
            }else{
                _commentModel.is_praise = @"1";
                praiseNum++;
            }
            _commentModel.hits = [NSString stringWithFormat:@"%ld",praiseNum];
            [self updateWithModel];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
-(void)updateWithModel
{
    [self.headerBtn sd_setImageWithURL:IMG_URL(_commentModel.image) forState:UIControlStateNormal];
    self.nameLab.text = _commentModel.nickname;
    self.timeLab.text = _commentModel.created_at;
    
    if ([_commentModel.is_praise isEqualToString:@"1"]) {
        self.praiseImgV.image = [UIImage imageNamed:@"isPraise"];
    }else{
        self.praiseImgV.image = [UIImage imageNamed:@"notPraise"];
    }
    self.numLab.text = _commentModel.hits;
    NSString * commentStr;
    if (_commentModel.replyName.length > 0) {
        commentStr = [NSString stringWithFormat:@"回复 :%@ %@ ",_commentModel.replyName,_commentModel.comment];
    }else{
        commentStr = _commentModel.comment;
    }
    
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:commentStr];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    if (_commentModel.replyName.length > 0) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(14, 124, 244) range:NSMakeRange(4,_commentModel.replyName.length)];
    }
    
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_commentModel.comment length])];
    self.contentLab.attributedText = attributedString;
    
    
}



@end
