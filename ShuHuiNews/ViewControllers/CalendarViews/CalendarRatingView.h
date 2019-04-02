//
//  LHRatingView.h
//  TestStoryboard
//
//  Created by bosheng on 15/11/4.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarRatingView;

@protocol ratingViewDelegate <NSObject>

@optional
- (void)ratingView:(CalendarRatingView *)view score:(CGFloat)score;

@end

typedef NS_ENUM(NSUInteger, RatingType) {
    INTEGER_TYPE,
    FLOAT_TYPE
};;

@interface CalendarRatingView : UIView

@property (nonatomic,assign)RatingType ratingType;//评分类型，整颗星或半颗星
@property (nonatomic,assign)CGFloat score;//当前分数

@property (nonatomic,assign)BOOL threeStar;//如果三星以上则显示蓝色
- (void)setUpContentView;
@property (nonatomic,assign)id<ratingViewDelegate> delegate;

@end
