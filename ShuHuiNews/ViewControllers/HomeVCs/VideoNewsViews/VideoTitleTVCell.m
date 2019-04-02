//
//  VideoTitleTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "VideoTitleTVCell.h"

@implementation VideoTitleTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)likeBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_titleModel.auth_id forKey:@"auth_id"];
    
    [bodyDic setObject:_titleModel.is_attention forKey:@"status"];
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JFansSome Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                if ([_titleModel.is_attention isEqualToString:@"1"]) {
                    _titleModel.is_attention = @"2";
                }else{
                    _titleModel.is_attention = @"1";
                }
                [self updateWithModel];
            }
            
        }
    }];
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    _titleModel.isShowMore = !_titleModel.isShowMore;
     [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
-(void)updateWithModel
{
    self.titleLab.text = _titleModel.title;
    [self.headerBtn sd_setImageWithURL:IMG_URL(_titleModel.head_portrait) forState:UIControlStateNormal];
    self.nameLab.text = [NSString stringWithFormat:@"%@·%@",_titleModel.issue,_titleModel.updatetime];
    self.tagFLab.text = [NSString stringWithFormat:@"   %@   ",_titleModel.class1name];
    self.tagSLab.text = [NSString stringWithFormat:@"   %@   ",_titleModel.class2name];
    self.tagTLab.text = [NSString stringWithFormat:@"   %@   ",_titleModel.class3name];
    
    if (_titleModel.canShowMore) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
    if (_titleModel.isShowMore) {
        self.contentLab.numberOfLines = 0;
         [self.moreBtn setImage:IMG_Name(@"grayArrowClose") forState:UIControlStateNormal];
    }else{
        self.contentLab.numberOfLines = 1;
        [self.moreBtn setImage:IMG_Name(@"grayArrowMore") forState:UIControlStateNormal];
    }
    
    if ([_titleModel.is_attention isEqualToString:@"1"]) {
        [self.likeBtn setImage:nil forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.likeBtn.backgroundColor = RGBCOLOR(208, 208, 208);
        
    }else{
        
        [self.likeBtn setImage:IMG_Name(@"detailAdd") forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.likeBtn.backgroundColor = RGBCOLOR(14, 124, 244);
    }
    
    if (_titleModel.content.length <1) {
        self.contentBV.hidden = YES;
    }else{
        self.contentBV.hidden = NO;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleModel.content];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleModel.content length])];
    self.contentLab.attributedText = attributedString;

    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
