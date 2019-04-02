//
//  YYStockTableViewCell.m
//  Treasure
//
//  Created by 耿一 on 16/5/25.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "ChainTableViewCell.h"

#define RedColor [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1.0]
#define ORIGINALCOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define REDBACKCOLOR [UIColor colorWithRed:248/255.0 green:191/255.0 blue:190/255.0 alpha:1.0]
#define GREENBACKCOLOR [UIColor colorWithRed:187/255.0 green:232/255.0 blue:187/255.0 alpha:1.0]
//#define NameColor [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@implementation ChainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//end用来判断是不是最后一个cell
- (void)updateWithModel:(ChainDetailModel *)detailModel changeColor:(NSInteger) changeColor isOrNotBiger:(NSInteger)isOrNotBiger
{
    
    self.contentV.backgroundColor = ORIGINALCOLOR;
    
    
    CTickerModel * tickerModel  = detailModel.ticker;
    
    self.marketNLab.text = detailModel.name;
    self.volumeLab.text = [NSString stringWithFormat:@"交易量 %@",[GYToolKit changeWithFormat:3 FloatNumber:tickerModel.volume]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",[GYToolKit changeWithFormat:2 FloatNumber:detailModel.chinaP]];
    
    self.convertLab.text = [NSString stringWithFormat:@"%@%@",[self getConvertStrWtihName:detailModel.currency],[GYToolKit changeWithFormat:2 FloatNumber:tickerModel.last]];
    
    NSString * nameStr = [NSString stringWithFormat:@"%@/%@",detailModel.coin,detailModel.currency];
    self.titleLab.text = [nameStr uppercaseString];
    
    NSString * percentStr = [NSString stringWithFormat:@"%@%%",[GYToolKit changeWithFormat:2 FloatNumber:detailModel.mp]];
    
    if(tickerModel.last > tickerModel.price_24h_before ) {
        
        self.percentLab.text = [NSString stringWithFormat:@"+%@",percentStr];
        self.priceLab.textColor = UIColorFromRGB(0x32cd32);
        self.percentLab.backgroundColor =  UIColorFromRGB(0x32cd32);
        if (changeColor) {
            if (isOrNotBiger) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                    self.contentV.backgroundColor = GREENBACKCOLOR;
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                } completion:^(BOOL finished) {
                    
                }];
                
                
            }else{
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                    self.contentV.backgroundColor = REDBACKCOLOR;
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
    }else{
        self.percentLab.text = percentStr;
        self.priceLab.textColor = RedColor;
        self.percentLab.backgroundColor = RedColor;
        if (changeColor) {
            if (isOrNotBiger) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                    self.contentV.backgroundColor = GREENBACKCOLOR;
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                } completion:^(BOOL finished) {
                    
                }];
            }else{
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                    self.contentV.backgroundColor = REDBACKCOLOR;
                    self.contentV.backgroundColor = ORIGINALCOLOR;
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
        
    }
}
- (NSString *)getConvertStrWtihName:(NSString *)name
{
    NSString * convert = @"$";
    if ([name isEqualToString:@"usd"]) {
        convert = @"$";
    }else if ([name isEqualToString:@"btc"]){
        convert = @"฿";
    }else if ([name isEqualToString:@"jpy"]){
        convert = @"円";
    }else if ([name isEqualToString:@"krw"]){
        convert = @"₩";
    }
    
    return convert;

}
@end
