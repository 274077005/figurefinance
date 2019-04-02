//
//  applyTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/5.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ApplyTVCell.h"

@implementation ApplyTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)applyBtnClick:(UIButton *)sender {
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_acModel.theId forKey:@"activity_id"];

    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JApplyOne Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 0) {
                [SVProgressHUD showWithString:@"报名成功~"];
            }else if([jsonDic[@"code"] integerValue] == 10000){
                [SVProgressHUD showWithString:@"您已报名"];
            }
        }
    }];
    
    
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString * aesStr= [GYAES encryptUseAES:[UserInfo share].uId key:@"6461772803150152" iv:@"8105547186756005"];
    
    NSString * shareStr;
    if ([_acModel.herf_url containsString:@"?"]) {
        shareStr = [NSString stringWithFormat:@"%@&user_msg=%@",_acModel.herf_url,aesStr];
    }else{
        shareStr = [NSString stringWithFormat:@"%@?user_msg=%@",_acModel.herf_url,aesStr];
    }
    
    NSString * titleStr;
    
    if (_acModel.site_description.length < 1) {
        titleStr = @"数汇资讯";
    }else{
        titleStr = _acModel.site_description;
    }
    
    
    NSArray* imageArray = @[[UIImage imageNamed:@"appIcon"]];
    [shareParams SSDKSetupShareParamsByText:@"  "
                                     images:imageArray
                                        url:IMG_URL(shareStr)
                                      title:titleStr
                                       type:SSDKContentTypeWebPage];
    [GYToolKit shareSDKToShare:shareParams];
    
}

-(void)updateWithModel
{
    self.titleLab.text = _acModel.name;
}
@end
