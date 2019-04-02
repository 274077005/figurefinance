//
//  RDHeaderTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDHeaderTVCell.h"

@implementation RDHeaderTVCell
{
    NSArray * _levelImgArr;
    NSArray * _levelNameArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView * ballView = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    ballView.backgroundColor = RGBCOLOR(35, 122, 229);
    [self addSubview:ballView];
    _levelImgArr = @[@"levelNormal",@"levelSilver",@"levelGold",@"levelPlatinum",@"levelDiamond"];
    _levelNameArr = @[@"普通会员",@"白银会员",@"黄金会员",@"铂金会员",@"钻石会员"];
    // Initialization code
}
- (void)updateWithModel
{
    [self.headerImgV sd_setImageWithURL:IMG_URL(_deModel.image)];
    self.nameLab.text = _deModel.nickname;
    if (_deModel.company_establish_time.length > 1) {
        self.timeAndCountryLab.text = [NSString stringWithFormat:@"成立时间:%@    所属国家:%@",_deModel.company_establish_time,_deModel.company_country];
    }

    
    if ([_userModel.is_collection isEqualToString:@"1"]) {
        [self.likeBtn setImage:nil forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:IMG_Name(@"detailAdd") forState:UIControlStateNormal];
        [self.likeBtn setTitle:@" 关注" forState:UIControlStateNormal];
    }
    NSInteger level = [_deModel.level integerValue];
    self.gradeImgV.image = [UIImage imageNamed:_levelImgArr[level]];
    self.gradeLab.text = _levelNameArr[level];
}

- (IBAction)likeBtnClick:(UIButton *)sender {
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_userModel.auth_id forKey:@"auth_id"];
    
    [bodyDic setObject:_userModel.is_collection forKey:@"status"];
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JFansSome Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                if ([_userModel.is_collection isEqualToString:@"1"]) {
                    _userModel.is_collection = @"2";
                }else{
                    _userModel.is_collection = @"1";
                }
                [self updateWithModel];
            }
            
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
