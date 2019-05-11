//
//  ZWWorksHeaderView.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWWorksHeaderView : UIView



- (IBAction)clickMoreButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;

@property (nonatomic,strong)NSArray *worksList;

@end

NS_ASSUME_NONNULL_END
