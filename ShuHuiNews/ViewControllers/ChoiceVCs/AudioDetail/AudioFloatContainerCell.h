//
//  AudioFloatContainerCell.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FloatContainerCellDelegate <NSObject>

@optional
- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface AudioFloatContainerCell : UITableViewCell
- (void)configScrollView;
@property (nonatomic,strong) UIViewController *VC;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL objectCanScroll;
@property (nonatomic,assign) BOOL isSelectIndex;
@property (strong, nonatomic)NSDictionary *dataDict;
@property (nonatomic,weak)   id<FloatContainerCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
