//
//  RingTagTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingRootModel.h"
#import "RingTagCVCell.h"
@interface RingTagTVCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,strong)RingRootModel * ringModel;
@property(nonatomic,strong)RingStatusModel * statusModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;


@property(nonatomic,weak)UITableView * tableView;
- (void)updateWithRingModel;


@property(nonatomic,copy)void(^refreshBlock)(void);

@end
