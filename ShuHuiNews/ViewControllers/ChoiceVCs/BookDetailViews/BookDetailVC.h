//
//  BookDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "BookDetailModel.h"
#import "BookBannerTVCell.h"
#import "BookInfoTVCell.h"
#import "SubmitOrderVC.h"
@interface BookDetailVC : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *byBtnBV;

@property(nonatomic,strong)BookDetailModel * detailModel;
@property(nonatomic,copy)NSString * bookId;


//是否从书籍列表页过来的
@property(nonatomic,assign)BOOL moreListToHere;

@end
