//
//  CenterAttestationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface CenterAttestationTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;

@property(nonatomic,strong)MainCenterModel * centerModel;
-(void)updateWithModel;

@end
