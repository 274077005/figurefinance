//
//  UIFactory.h
//  wemex
//
//  Created by Zach on 2017/12/13.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonEx : UIButton
@property (nonatomic, retain)id info;
@end

UIImageView* newImageView(NSArray* params);

UIButton* newButton(NSArray* params);

UIButtonEx* newButtonEx(NSArray* params);

UILabel* newLabel(NSArray* params);

UIView* newView(NSArray* params);

UITextField* newTextField(NSArray* params);

UITextView* newTextView(NSArray* params);

UITextView* newLimitTextView(NSArray* params);
