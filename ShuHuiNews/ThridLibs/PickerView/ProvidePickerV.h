//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasicPickerDelegate <NSObject>

@optional;
- (void)PickerSelectorIndixString:(NSString *)str;

@end

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    urlType, //网址类型
    countryType, //国家类型
    periodType,  //工作时长
    educationType,//学历
    marriageType,//婚姻状态
    timeType,//婚姻状态
    

};

@interface ProvidePickerV : UIView

@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic, strong) NSArray *customArr;

@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic,assign)id<BasicPickerDelegate>delegate;

@end
