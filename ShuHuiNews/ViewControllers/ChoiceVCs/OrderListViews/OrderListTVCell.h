//
//  OrderListTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface OrderListTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deliveryLab;
@property (weak, nonatomic) IBOutlet UILabel *timerLab;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLab;
@property (weak, nonatomic) IBOutlet UILabel *publishLab;
@property (weak, nonatomic) IBOutlet UILabel *autherLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;


@property(nonatomic,strong)OrderListModel * listModel;

-(void)updateWithModel;
@end
