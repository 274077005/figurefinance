//
//  RingNormalTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingRootModel.h"
@interface RingNormalTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (nonatomic,strong)RingListModel * listModel;

- (void)updateWithModel;
@end
