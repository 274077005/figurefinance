//
//  SpecialHeaderV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialHeaderV : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property(nonatomic,copy)NSDictionary * contentDic;

-(void)setUpContentView;

@end
