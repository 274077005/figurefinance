//
//  RDRelationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RDRelationTVCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,strong) RingDetailModel * deModel;

- (void)updateWithModel;
@end
