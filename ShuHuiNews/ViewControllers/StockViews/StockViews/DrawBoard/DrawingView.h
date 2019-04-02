//
//  DrawingView.h
//  DrawingViewDemo
//
//  Created by xxss0903 on 16/3/17.
//  Copyright © 2016年 rry.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "DrawingTool.h"

@class DrawingView;

typedef enum : NSUInteger {
    DrawingToolTypePen,
    DrawingToolTypeLine,
    DrawingToolTypeOval,
    DrawingToolTypeRectangle,
    DrawingToolTypeRectangleFill,
    DrawingToolTypeOvalFill,
    DrawingToolTypeText,
    DrawingToolTypeMultiText,
    DrawingToolTypeArrow,
    DrawingToolTypeEraser
} DrawingToolType;

@protocol DrawingViewDelegate <NSObject>

- (void)drawingViewDidFinishedDraw:(DrawingView *)drawingView;

@end

@interface DrawingView : UIView

@property (nonatomic, strong) id<DrawingViewDelegate> delegate;
@property (nonatomic, strong) id<DrawingToolDelegate> DrawingTool;
@property (nonatomic, assign) DrawingToolType drawToolType;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

@property (nonatomic, strong) UITextView *textView;


- (void)undoLastObject;
- (BOOL)canundo;
- (void)redoLastObject;
- (BOOL)canredo;
- (void)clearScreen;

@end
