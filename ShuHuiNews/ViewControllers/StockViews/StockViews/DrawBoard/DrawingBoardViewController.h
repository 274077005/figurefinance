//
//  DrawingBoardViewController.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 2016/12/29.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
@interface DrawingBoardViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *drawImgV;
@property (weak, nonatomic) IBOutlet DrawingView *drawingView;


@property (weak, nonatomic) IBOutlet UIButton *lineTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *lineTypeFirstBtn;

@property (weak, nonatomic) IBOutlet UIButton *lineTypeSecondBtn;

//颜色选择按钮

@property (weak, nonatomic) IBOutlet UIButton *drawColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorSecondBtn;



@property (weak, nonatomic) IBOutlet UIButton *drawTextBtn;




@property (strong, nonatomic) UIImage * drawImage;
@end
