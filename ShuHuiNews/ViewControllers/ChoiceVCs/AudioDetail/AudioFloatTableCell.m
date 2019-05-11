//
//  AudioFloatTableCell.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "AudioFloatTableCell.h"
#import "UIImageView+WebCache.h"

@implementation AudioFloatTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_dict[@"image"]]];
    self.nameLabel.text = _dict[@"nickname"];
    self.focusLabel.text = [NSString stringWithFormat:@"%@关注",_dict[@"fens_num"]];
    //判断是否已经关注
    if(self.isFocus){
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

- (IBAction)clickFocusButton:(UIButton *)sender {
    //关注或者取消关注
    if (!self.isFocus) {
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //关注作者
        [self attention];
    }else{
        [self.focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //取消关注
        [self disAttention];
    }
}

- (void)disAttention{
    
}


- (void)attention{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_dict[@"id"] forKey:@"auth_id"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyAttention Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                [SVProgressHUD dismissWithDelay:0.7];
                
            }
        }else{
            
        }
        
        
    }];
}
@end
