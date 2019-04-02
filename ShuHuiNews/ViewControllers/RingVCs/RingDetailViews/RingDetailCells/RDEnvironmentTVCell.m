//
//  CenterEnvironmentTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDEnvironmentTVCell.h"
#import "TheEnvironmentICVCell.h"
#import "EditEnvironmentVC.h"
@implementation RDEnvironmentTVCell{
    //滚动视图的item数组
    NSMutableArray *_itemArray;
    //用于记录每个按钮的偏移量
    NSMutableArray *_itemInfoArray;
    //按钮数组
    NSMutableArray *_buttonArray;
    //滚动视图上的线视图
    UIView *_lineView;
    //记录下每个item按钮的长度
    NSMutableArray * _itemWithArray;
    
    //记录滚动视图的长度
    float _totalWidth;
    
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    
    
    // Initialization code
}
- (IBAction)addBtnClick:(UIButton *)sender {
    
    EditEnvironmentVC * enVC = [[EditEnvironmentVC alloc]init];
    [self.viewContoller.navigationController pushViewController:enVC animated:YES];
    
}


-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    self.contentView.layer.masksToBounds = YES;
    _BVLayer.position = _shadowBV.layer.position;
    _BVLayer.frame = _shadowBV.frame;
    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
    _BVLayer.shadowOffset = CGSizeMake(2, 2);
    _BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    
}
-(void)updateWithModel{
    
    
    
    [self createMenuScrollView];
    [self layoutIfNeeded];
    self.iCarouselV.pagingEnabled = YES;
    self.iCarouselV.currentItemIndex = 0;
    self.iCarouselV.bounces = NO;
    [self.iCarouselV reloadData];
    
    
}
//创建菜单上的按钮
-(void)createMenuScrollView{
    
    [self.menuScrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    _itemWithArray = [[NSMutableArray alloc] init];
    
    
    _itemInfoArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    
    //创建其他的市场按钮
    float menuWidth = 0.0;
    for (int i = 0;i < self.centerModel.environmentArr.count; i++) {
        NSInteger itemWidth = 60;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CenterEnvironmentModel * menuMdeol = self.centerModel.environmentArr[i];
        NSString *str = menuMdeol.account;
        NSInteger len = [str length];
        if (len >= 3) {
            itemWidth = 80;
            if(len > 4){
                itemWidth = 90;
            }
        }
        button.frame = CGRectMake(menuWidth, 0, itemWidth, 38);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(105, 105, 105) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        //button.backgroundColor = [UIColor blackColor];
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self.menuScrollV addSubview:button];
        
        [_itemInfoArray addObject:@(menuWidth)];
        menuWidth += itemWidth;
        
        [_buttonArray addObject:button];
        [_itemWithArray addObject:@(itemWidth)];
        
    }
    
    
    self.menuScrollV.contentOffset = CGPointMake(0, 0);
    
    
    _totalWidth = menuWidth;
    [self.menuScrollV setContentSize:CGSizeMake(menuWidth, 40)];
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(20, 40 - 5,35, 2);
    _lineView.backgroundColor = RGBCOLOR(14, 124, 244);
    [self.menuScrollV addSubview:_lineView];
    [self changeButtonStateAtIndex:0];
    
    
    
}
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    
    
    return self.centerModel.environmentArr.count;
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    TheEnvironmentICVCell * CellView = (TheEnvironmentICVCell*)view;
    if (CellView == nil) {
        CellView = [[[NSBundle mainBundle] loadNibNamed:@"TheEnvironmentICVCell" owner:nil options:nil] firstObject];
        
        CellView.frame = CGRectMake(0, 0, _iCarouselV.width, _iCarouselV.height);
        CellView.layer.masksToBounds = YES;
        
    }
    
    CenterEnvironmentModel * enModel = self.centerModel.environmentArr[index];
    CellView.enModel = enModel;
    [CellView updateWithModel];
    return CellView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了:%ld",index);
    
    
    
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    
    
    return  _iCarouselV.width;
    
    //    return self.iCarouselV.width;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            //            NSLog(@"value:%f",value);
            return value * 1.00;
        }
        case iCarouselOptionFadeMax:
        {
            if (_iCarouselV.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
    //    NSLog(@"FFF:%ld",carousel.currentItemIndex);
    if (carousel == _iCarouselV) {
        [self changeButtonStateAtIndex:carousel.currentItemIndex];
    }
    
    
}

#pragma mark - ScrollView点击事件
- (void)menuButtonClicked:(UIButton *)btn {
    [self changeButtonStateAtIndex:btn.tag];
    [self.iCarouselV scrollToItemAtIndex:btn.tag animated:YES];
    //点击btn有动画效果滚动
    //    [self.collectionV setContentOffset:CGPointMake(SCREEN_WIDTH*btn.tag, 0) animated:YES];
    //NSLog(@"%f",SCREEN_WIDTH*btn.tag);
}


//改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index {
    
    NSInteger location = [[_itemInfoArray objectAtIndex:index] integerValue];
    NSInteger with = [[_itemWithArray objectAtIndex:index] integerValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        //设置顺序不对会有错误
        _lineView.transform = CGAffineTransformMakeTranslation(location, 0);
        [_lineView setFrame:CGRectMake(location + 12, 40 - 5, with - 24, 2)];
        
        
    }];
    UIButton *button = [_buttonArray objectAtIndex:index];
    [self changeButtonsToNormalState];
    button.selected = YES;
    if (index !=0) {
        [self moveMenuVAtIndex:index];
    }
    
}

//取消所有button点击状态
-(void)changeButtonsToNormalState {
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}

//移动button到可视的区域
- (void)moveMenuVAtIndex:(NSInteger)index {
    if (_itemInfoArray.count < index) {
        return;
    };
    //宽度小于320肯定不需要移动
    CGFloat Width = _menuScrollV.frame.size.width;
    if (_totalWidth <= Width) {
        return;
    }
    float buttonOrigin = [_itemInfoArray[index] floatValue];
    if (buttonOrigin >= Width - 180) {
        if ((buttonOrigin - 180) >= _menuScrollV.contentSize.width - Width) {
            [_menuScrollV setContentOffset:CGPointMake(_menuScrollV.contentSize.width - Width, _menuScrollV.contentOffset.y) animated:YES];
            
            return;
        }
        
        float moveToContentOffset = buttonOrigin - 180;
        if (moveToContentOffset > 0) {
            [_menuScrollV setContentOffset:CGPointMake(moveToContentOffset, _menuScrollV.contentOffset.y) animated:YES];
            
        }
    }else{
        [_menuScrollV setContentOffset:CGPointMake(0, _menuScrollV.contentOffset.y) animated:YES];
        
        return;
    }
}


@end
