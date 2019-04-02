//
//  QADetailHeaderV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "QADetailHeaderV.h"

@implementation QADetailHeaderV




- (void)updateWithModel
{
    [self.headerBtn sd_setImageWithURL:_QAModel.user.image forState:UIControlStateNormal placeholderImage:IMG_Name(@"headerHold")];
    self.nameLab.text = _QAModel.user.nickname;
    self.timeLab.text = [NSString stringWithFormat:@"%@·%@",_QAModel.created_at,_QAModel.type.name];
    self.contentLab.text = _QAModel.question;
    self.priceLab.text = [NSString stringWithFormat:@"悬赏:%@",_QAModel.price];
    self.endTimeLab.text = [NSString stringWithFormat:@"距离问答结束还有:%@",_QAModel.end_time];
    if ([_QAModel.end_time isEqualToString:@"已结束"]) {
        _answerBtn.backgroundColor = RGBCOLOR(204, 204, 204);
        _answerBtn.userInteractionEnabled = NO;
        
    }
}
- (IBAction)headerBtnClick:(UIButton *)sender {
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = _QAModel.user.theId;
    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    
    
}




- (IBAction)answerBtnClick:(UIButton *)sender {
    
    if (self.submitBlock) {
        self.submitBlock();
    }
}

@end
