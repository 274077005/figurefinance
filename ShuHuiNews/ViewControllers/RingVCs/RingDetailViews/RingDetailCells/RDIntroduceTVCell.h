//
//  RDIntroduceTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
@interface RDIntroduceTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;

@property(nonatomic,strong) RingDetailModel * deModel;

- (void)updateWithModel;

@end
