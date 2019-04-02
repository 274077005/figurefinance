//
//  HomeSearchVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeSearchCVCell.h"
#import "SearchCVHeaderV.h"
@class HomeRecommendV;

@interface HomeSearchVC : BaseViewController<GYCollectionLayoutDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBV;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;



@property(nonatomic,strong)HomeRecommendV * recommendV;
@end
