//
//  AudioFloatTableCell.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioFloatTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *focusLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (strong, nonatomic) NSDictionary *dict;
@property (assign, nonatomic) BOOL isFocus;
- (IBAction)clickFocusButton:(UIButton *)sender;

- (void)setDict:(NSDictionary * _Nonnull)dict;
@end

NS_ASSUME_NONNULL_END
