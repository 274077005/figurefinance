//
//  RDCommentTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/31.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheRDComTVCell.h"
#import "RingDetailModel.h"
#import "DlgCommentV.h"
#import "DlgCommentWayV.h"
#import "RDCommentVC.h"
@interface RDCommentTVCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *noCommentBV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *listBV;
-(void)updateWithModel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property(nonatomic,strong)RingDetailModel * deModel;

@property(nonatomic,strong)DlgCommentV * commentV;

@property(nonatomic,strong)DlgCommentWayV * wayV;

@property(nonatomic,copy)NSString * commentStr;

@property(nonatomic,copy)NSString * chooseCId;

@property(nonatomic,copy)NSString * companyId;

@property(nonatomic,copy)void(^commentBlock)(void);

@property (nonatomic,strong)NSArray *articleList;

- (IBAction)clickMoreArticle:(id)sender;


@end
