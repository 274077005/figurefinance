//
//  OrderListTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "OrderListTVCell.h"

@implementation OrderListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)updateWithModel
{
    
    self.deliveryLab.text = [NSString stringWithFormat:@"物流编号:%@",_listModel.delivery_id];
    self.timerLab.text = [NSString stringWithFormat:@"下单时间:%@",_listModel.created_at];
    self.bookNameLab.text = _listModel.name;
    [self.coverImgV sd_setImageWithURL:_listModel.img_info];
    self.publishLab.text = _listModel.publish;
    self.autherLab.text = [NSString stringWithFormat:@"作者:%@",_listModel.author];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",_listModel.total_price];
    if ([_listModel.status integerValue] == 0) {
        self.statusLab.text = @"未发货";
    }else{
        self.statusLab.text = @"已发货";
    }
}
@end
