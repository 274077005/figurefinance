//
//  ChoiceVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "ChoiceBannerV.h"
#import "ChoiceTVCell.h"
#import "ChoiceModel.h"
#import "BookCVCell.h"
#import "ChoiceModel.h"
#import "BookTagHeaderV.h"
#import "BookDetailVC.h"
#import "AudioViewController.h"
#import "ChoiceVideoDetailViewController.h"
#import "ChoiceBookDetailViewController.h"

//#import "SDCycleScrollView.h"
@interface ChoiceVC : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)ChoiceBannerV * bannerV;
//@property(nonatomic,strong)SDCycleScrollView * bannerV;

@property (nonatomic,strong)UICollectionView * collectionV;

@property(nonatomic,strong)ChoiceModel * choiceModel;


@end
