//
//  YYStockTableViewCell.h
//  Treasure
//
//  Created by 耿一 on 16/5/25.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChainDetailModel.h"
@interface ChainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UILabel *marketNLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeLab;
@property (weak, nonatomic) IBOutlet UILabel *convertLab;

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *lineView;


- (void)updateWithModel:(ChainDetailModel *)detailModel changeColor:(NSInteger) changeColor isOrNotBiger:(NSInteger)isOrNotBiger;
@end
