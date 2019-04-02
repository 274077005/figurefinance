//
//  YYStockTableViewCell.h
//  Treasure
//
//  Created by 耿一 on 16/5/25.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockDetailModel.h"
@interface StockTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *changeLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whetherEnd;


- (void)updateWithModel:(StockDetailModel *)appMarketDetailModel changeColor:(NSInteger) changeColor isOrNotBiger:(NSInteger)isOrNotBiger end:(NSInteger)end;
@end
