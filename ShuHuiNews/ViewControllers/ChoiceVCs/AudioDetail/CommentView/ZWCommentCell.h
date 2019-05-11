//
//  ZWCommentCell.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/27.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (strong,nonatomic) NSDictionary* commentDict;

- (IBAction)clickReportButton:(id)sender;

- (void)setCommentDict:(NSDictionary * _Nonnull)commentDict;

@end

NS_ASSUME_NONNULL_END
