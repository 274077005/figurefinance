//
//  FlashShareV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/29.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"
@interface FlashShareV : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

-(void)updateWithContentStr:(FlashModel *)model;
@end
