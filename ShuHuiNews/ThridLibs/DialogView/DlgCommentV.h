//
//  DlgCommentV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/13.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DlgCommentV : DialogBase<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *holdLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvBottom;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(nonatomic,copy)void(^submitBlock)(NSString * commentStr);
@end
