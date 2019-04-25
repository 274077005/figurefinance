//
//  FloatContainerCell.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/13.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FloatContainerCellDelegate <NSObject>

@optional
- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
@interface FloatContainerCell : UITableViewCell
- (void)configScrollView;
@property (nonatomic,strong) UIViewController *VC;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL objectCanScroll;
@property (nonatomic,assign) BOOL isSelectIndex;
@property (nonatomic,weak)   id<FloatContainerCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
