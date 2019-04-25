//
//  AudioViewController.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/12.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"
#import "ZWOrderDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioViewController : UIViewController

@property (weak,nonatomic)UILabel *priceLabel;
@property (weak,nonatomic)UIButton *priceButton;
@property (copy,nonatomic)NSString *bookId;
@property (assign,nonatomic)NSInteger type;
@property (strong,nonatomic)NSDictionary *bookDetailDict;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

- (IBAction)clickFocusButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
