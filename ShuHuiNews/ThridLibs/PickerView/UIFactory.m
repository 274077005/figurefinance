//
//  UIFactory.m
//  wemex
//
//  Created by Zach on 2017/12/13.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import "UIFactory.h"


static unsigned int g_tag = 60000;

@implementation UIButtonEx
@end

// params: imageName, frame
UIImageView* newImageView(NSArray* params) {
    UIImageView* imgv = nil;
    if ( [params[0] isEqualToString:@""] ) {
        imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placehold"]];
    } else {
        imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:params[0]]];
    }
    imgv.tag = g_tag++;
    imgv.clipsToBounds = YES;
    if (params.count >= 2) {
        CGRect frame = id2rect(params[1]);
        if (frame.size.width==0 && frame.size.height==0) {
            imgv.fx = frame.origin.x;
            imgv.fy = frame.origin.y;
        } else {
            imgv.frame = frame;
        }
    }
    return imgv;
}

// params: frame, target, selector
UIButton* newButton(NSArray* params) {
    UIButton* btn = [[UIButton alloc] initWithFrame:id2rect(params[0])];
    if (params.count>=3 && ![params[2] isEqual:[NSNull null]]) {
        [btn addTarget:params[1] action:id2sel(params[2]) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.backgroundColor = [UIColor clearColor];
    btn.clipsToBounds = YES;
    //btn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.tag = g_tag++;
    return btn;
}

UIButtonEx* newButtonEx(NSArray* params) {
    UIButtonEx* btn = [[UIButtonEx alloc] initWithFrame:id2rect(params[0])];
    if (params.count>=3 && ![params[2] isEqual:[NSNull null]]) {
        [btn addTarget:params[1] action:id2sel(params[2]) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.backgroundColor = [UIColor clearColor];
    btn.clipsToBounds = YES;
    //btn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.tag = g_tag++;
    return btn;
}

// params: frame, textColor, font, Text
UILabel* newLabel(NSArray* params) {
    UILabel* label = [[UILabel alloc] initWithFrame:id2rect(params[0])];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = params[1];
    label.font = params[2];
    label.tag = g_tag++;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    if (params.count >= 4) {
        label.text = params[3];
    }

    return label;
}

// params: frame, backgroundColor
UIView* newView(NSArray* params) {
    UIView* view = [[UIView alloc] initWithFrame:id2rect(params[0])];
    view.tag = g_tag++;
    if (params.count >= 2) {
        view.backgroundColor = params[1];
    }
    return view;
}

// params: frame, textColor, font, placeholder, Text
UITextField* newTextField(NSArray* params) {
    UITextField *textField = [[UITextField alloc] initWithFrame:id2rect(params[0])];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.tag = g_tag++;
    textField.textColor = params[1];
    textField.font = params[2];
    textField.placeholder = params[3];
    textField.text = params[4];
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor clearColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.clipsToBounds = YES;
    textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    //[textField setValue:RGB(0x000000) forKeyPath:@"_placeholderLabel.textColor"]; //修改placeholder的颜色;
    //textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.fh)];
    //textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

//params: frame, textColor, font, Text
UITextView* newTextView(NSArray* params) {
    UITextView *obj = [[UITextView alloc] initWithFrame:id2rect(params[0])];
    obj.tag = g_tag++;
    obj.textColor = params[1];
    obj.font = params[2];
    obj.text = params[3];
    obj.returnKeyType = UIReturnKeyDone;
    obj.backgroundColor = [UIColor clearColor];
    obj.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return obj;
}

//params: frame, textColor, font, placehold, Text, limitLength

