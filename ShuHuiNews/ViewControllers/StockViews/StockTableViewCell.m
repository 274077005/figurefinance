//
//  YYStockTableViewCell.m
//  Treasure
//
//  Created by 耿一 on 16/5/25.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "StockTableViewCell.h"

#define RedColor [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1.0]
#define ORIGINALCOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define REDBACKCOLOR [UIColor colorWithRed:248/255.0 green:191/255.0 blue:190/255.0 alpha:1.0]
#define GREENBACKCOLOR [UIColor colorWithRed:187/255.0 green:232/255.0 blue:187/255.0 alpha:1.0]
//#define NameColor [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@implementation StockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//end用来判断是不是最后一个cell
- (void)updateWithModel:(StockDetailModel *)appMarketDetailModel changeColor:(NSInteger) changeColor isOrNotBiger:(NSInteger)isOrNotBiger end:(NSInteger)end
{
    if (end) {
        self.whetherEnd.constant = 0;
    }else{
        self.whetherEnd.constant = 10;
    }
    self.contentV.backgroundColor = ORIGINALCOLOR;

    self.titleLab.text = appMarketDetailModel.name;
//    self.titleLab.textColor = NameColor;
    self.priceLab.text = appMarketDetailModel.nowP;
    self.changeLab.text = appMarketDetailModel.margin;
    self.percentLab.text = [NSString stringWithFormat:@"%@",appMarketDetailModel.mp];
    //判断该显示什么颜色
    if ([appMarketDetailModel.name isEqualToString:@"美元人民币"]) {
        NSLog(@"%@",appMarketDetailModel.nowP);
        NSLog(@"%@",appMarketDetailModel.lastClose);
        
    }
    if ([appMarketDetailModel.lastClose isEqualToString:@"0"]) {
        
        if ([appMarketDetailModel.nowP floatValue] > [appMarketDetailModel.lastClose floatValue]) {
            self.priceLab.textColor = RedColor;
            self.changeLab.textColor = RedColor;
            self.percentLab.backgroundColor =  RedColor;
            if (changeColor) {
                if (isOrNotBiger) {
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = REDBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];
                }else{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = GREENBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                    }];
                }
            }
        }else{
            self.priceLab.textColor = UIColorFromRGB(0x32cd32);
            self.changeLab.textColor = UIColorFromRGB(0x32cd32);
            self.percentLab.backgroundColor =  UIColorFromRGB(0x32cd32);
            if (changeColor) {
                if (isOrNotBiger) {
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = REDBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];

                    
                }else{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = GREENBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];

                }
                
            }


        }
    }else{
        if([appMarketDetailModel.nowP floatValue] > [appMarketDetailModel.lastClose floatValue]) {
            self.priceLab.textColor = RedColor;
            self.changeLab.textColor = RedColor;
            self.percentLab.backgroundColor = RedColor;
            if (changeColor) {
                if (isOrNotBiger) {
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = REDBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];

                    
                }else{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = GREENBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }
        }else{
            self.priceLab.textColor = UIColorFromRGB(0x32cd32);
            self.changeLab.textColor = UIColorFromRGB(0x32cd32);
            self.percentLab.backgroundColor =  UIColorFromRGB(0x32cd32);
            if (changeColor) {
                if (isOrNotBiger) {
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = REDBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                        self.contentV.backgroundColor = GREENBACKCOLOR;
                        self.contentV.backgroundColor = ORIGINALCOLOR;
                    } completion:^(BOOL finished) {
                        
                    }];
                }

            }

        }
        
        
    }

}
@end
