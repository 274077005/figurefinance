//
//  ChooseIndustryVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/12.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseIndustryVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *affirmBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

//2个人标签，3公司标签，4行业
@property(nonatomic,copy)NSString * industryType;

@property(nonatomic,copy)void(^submitBlock)(NSString *titleStr,NSString * idStr);

@end
