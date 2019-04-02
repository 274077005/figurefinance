//
//  DrawingTool.h
//  DrawingViewDemo
//
//  Created by xxss0903 on 16/3/17.
//  Copyright © 2016年 rry.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DrawingToolDelegate <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

- (void)draw;

@end


#pragma mark 画笔工具
@interface DrawingToolPen : UIBezierPath<DrawingToolDelegate>
{
    CGMutablePathRef path;
}

- (CGRect)addPathFromPPreviousPoint:(CGPoint)p1Point andPreviousPoint:(CGPoint)p2Point andCurrentPoint:(CGPoint)cPoint;

@end

#pragma mark 直线工具
@interface DrawingToolLine : NSObject<DrawingToolDelegate>

@end

#pragma mark 橡皮擦
@interface DrawingToolEraser : DrawingToolPen

@end

#pragma mark 矩形（不填充）
@interface DrawingToolRectangle : NSObject<DrawingToolDelegate>

@property (nonatomic, assign) BOOL isFill;

@end

#pragma mark 矩形（填充）
@interface DrawingToolOval : NSObject<DrawingToolDelegate>

@property (nonatomic, assign) BOOL isFill;

@end

#pragma mark 箭头
@interface DrawingToolArrow : NSObject<DrawingToolDelegate>


@end

#pragma mark 文本
@interface DrawingToolText : NSObject<DrawingToolDelegate>

@property (nonatomic, strong) NSAttributedString *attributedText;

@property (nonatomic, assign) BOOL isMultiText;

@end




