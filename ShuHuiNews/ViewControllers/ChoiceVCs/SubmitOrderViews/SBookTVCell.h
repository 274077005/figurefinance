//
//  SBookTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitOrderModel.h"

@interface SBookTVCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *publishLab;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *autherLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property(nonatomic,strong)SBookModel * bookModel;
@property(nonatomic,strong)SubmitNumModel * numModel;
@property(nonatomic,copy)void(^changeBlock)(void);

- (void)updateWithModel;

@end
