//
//  DrawingView.m
//  DrawingViewDemo
//
//  Created by xxss0903 on 16/3/17.
//  Copyright © 2016年 rry.com. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView () <UITextViewDelegate>



@end

@implementation DrawingView
{
    CGPoint p1Point;
    CGPoint p2Point;
    CGPoint cPoint;
    
    CGRect originRect;
}

#pragma mark - 自定义方法
- (void)finishDrawing
{

    [self updateImageWithRedraw:NO];
    
    if ([self.delegate respondsToSelector:@selector(drawingViewDidFinishedDraw:)]) {
        [self.delegate drawingViewDidFinishedDraw:self];
    }
}

- (void)updateImageWithRedraw:(BOOL)redraw
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NULL, 0.0);    // 开启一个图像上下文

    if (redraw) {
        self.image = nil;
        // 重绘
        for (id<DrawingToolDelegate> tool in self.pathArray) {
            [tool draw];
        }
    } else {
        [self.image drawAtPoint:CGPointZero];
        [self.DrawingTool draw];
    }
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.DrawingTool = nil;
}

// 初始化各种变量
- (void)configure
{
    self.DrawingTool = [DrawingToolPen new];
    self.drawToolType = DrawingToolTypeArrow;
    
    self.bufferArray = [NSMutableArray array];
    self.pathArray = [NSMutableArray array];
    self.image = [[UIImage alloc] init];
    
    self.lineWidth = 1.0f;
    self.lineColor = [UIColor orangeColor];
    self.lineAlpha = 1.0f;
    
    self.DrawingTool.lineWidth = self.lineWidth;
    self.DrawingTool.lineColor = self.lineColor;
    self.DrawingTool.lineAlpha = self.lineAlpha;
}

// 初始化当前画图工具
- (void)setupDrawTool
{
    // 设置工具
    self.DrawingTool = [self setupCurrentDrawTool];
    

}

// 返回当前画图工具
- (id<DrawingToolDelegate>)setupCurrentDrawTool
{
    switch (self.drawToolType) {
        case DrawingToolTypePen:
        {
            return [DrawingToolPen new];
        }
            
        case DrawingToolTypeLine:
        {
            return [DrawingToolLine new];
        }
            

            
        case DrawingToolTypeRectangle:
        {
            DrawingToolRectangle *tool = [DrawingToolRectangle new];
            tool.isFill = NO;
            return tool;
        }

        case DrawingToolTypeRectangleFill:
        {
            DrawingToolRectangle *tool = [DrawingToolRectangle new];
            tool.isFill = YES;
            return tool;
        }
            
        case DrawingToolTypeArrow:
        {
            DrawingToolArrow *tool = [DrawingToolArrow new];
            return tool;
        }
            
        case DrawingToolTypeOval:
        {
            DrawingToolOval *tool = [DrawingToolOval new];
            tool.isFill = NO;
            return tool;
        }
            
        case DrawingToolTypeOvalFill:
        {
            DrawingToolOval *tool = [DrawingToolOval new];
            tool.isFill = YES;
            return tool;
        }
            
        case DrawingToolTypeText:
        {
            DrawingToolText *tool = [DrawingToolText new];
            tool.isMultiText = NO;
            return tool;
        }
            
        case DrawingToolTypeMultiText:
        {
            DrawingToolText *tool = [DrawingToolText new];
            tool.isMultiText = YES;
            return tool;
        }
            
        case DrawingToolTypeEraser:
        {
            return [DrawingToolEraser new];
        }

    }
}

// 按钮响应方法
- (void)undoLastObject
{
    if ([self canundo]) {
        id<DrawingToolDelegate>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        
        [self updateImageWithRedraw:YES];
        
        [self setNeedsDisplay];
    }
}

- (BOOL)canundo
{
    return self.pathArray.count > 0;
}

- (void)redoLastObject
{
    if ([self canredo]) {
        id<DrawingToolDelegate>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        
        [self updateImageWithRedraw:YES];
        
        [self setNeedsDisplay];
    }
}

- (BOOL)canredo
{
    return self.bufferArray.count > 0;
}

- (void)clearScreen
{
    if (self.pathArray.count > 0 || self.bufferArray.count > 0) {
        [self.pathArray removeAllObjects];
        [self.bufferArray removeAllObjects];
        
        [self updateImageWithRedraw:YES];
        self.DrawingTool = nil;
        
        [self setNeedsDisplay];
    }
}

// 初始化文本框
- (void)initializeTextBoxWith:(CGPoint)StartPoint andMultiText:(BOOL)isMultiText
{
    // 初始化textview和参数
    if (!self.textView) {
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.borderColor = [UIColor grayColor].CGColor;
        self.textView.layer.cornerRadius = 8;
        [self.textView setContentInset:UIEdgeInsetsZero];
        
        [self addSubview:self.textView];
    }
    
    // 设置文本框的frame
    int fontSize = self.lineWidth * 10;
    
    [self.textView setFont:[UIFont systemFontOfSize:fontSize]];
    self.textView.textColor = self.lineColor;
    self.textView.alpha = self.lineAlpha;
    
    int defaultWidth = 200;
    int defaultHeight = fontSize * 2;
    int initialYPosition = StartPoint.y - (defaultHeight / 2);
    CGRect textFrame = CGRectMake(StartPoint.x, initialYPosition, defaultWidth, defaultHeight);
    textFrame = [self adjustTextViewFrameWithInitalFrame:textFrame];
    self.textView.frame = textFrame;
    self.textView.text = @"";
    self.textView.hidden = NO;
}

// 判断文本框是否在本视图之外
- (CGRect)adjustTextViewFrameWithInitalFrame:(CGRect)frame
{
    if ((frame.origin.x + frame.size.width) > self.frame.size.width) {
        frame.size.width = self.frame.size.width - frame.origin.x;
    }
    if ((frame.origin.y + frame.size.height) > self.frame.size.height) {
        frame.size.height = self.frame.size.height - frame.origin.y;
    }
    return frame;
}

// 移动坐标调整文本框的大小
- (void)resizeTextViewFrame:(CGPoint)adjustedSize
{
    int minimumAllowedHeight = self.textView.font.pointSize * 2;
    int minimumAllowedWidth = self.textView.font.pointSize * 0.5;
    
    CGRect frame = self.textView.frame;
    
    //adjust height
    int adjustedHeight = adjustedSize.y - self.textView.frame.origin.y;
    if (adjustedHeight > minimumAllowedHeight) {
        frame.size.height = adjustedHeight;
    }
    
    //adjust width
    int adjustedWidth = adjustedSize.x - self.textView.frame.origin.x;
    if (adjustedWidth > minimumAllowedWidth) {
        frame.size.width = adjustedWidth;
    }
    frame = [self adjustTextViewFrameWithInitalFrame:frame];
    
    self.textView.frame = frame;
}

// 文本框成为第一响应者
- (void)enterTextEdit
{
    if (!self.textView.hidden) {
        [self addNotificationToKeyboardAction];
        [self.textView becomeFirstResponder];
    }
}

// 文本框结束输入并将文字绘制到画板上
- (void)textViewDidEndInput
{
    NSLog(@"textView did end editing ...");
    [self.textView resignFirstResponder];
    
    // 将文本框重绘到绘画班上，然后将其保存到路径数组中
    if ([self.textView.text length]) {
        UIEdgeInsets textInset = self.textView.textContainerInset;
        CGFloat additionalXPadding = 5;
        CGPoint start = CGPointMake(self.textView.frame.origin.x + textInset.left + additionalXPadding, self.textView.frame.origin.y + textInset.top);
        CGPoint end = CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width - additionalXPadding, self.textView.frame.origin.y + self.textView.frame.size.height);
        
        ((DrawingToolText *)self.DrawingTool).attributedText = [self.textView.attributedText copy];
        
        [self.pathArray addObject:self.DrawingTool];
        
        [self.DrawingTool setInitialPoint:start]; //change this for precision accuracy of text location
        [self.DrawingTool movePointFrom:start toPoint:end];
        [self setNeedsDisplay];
        
        [self finishDrawing];
    }
    [self.textView removeFromSuperview];
    self.textView = nil;
    self.DrawingTool = nil;
    [self.textView setHidden:YES];
    
    NSLog(@"%d", self.textView.hidden);
}


#pragma mark - 文本框代理方法
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self textViewDidEndInput];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    originRect = self.frame;
    NSLog(@"self.origin = %@", NSStringFromCGRect(originRect));
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"textview change,%@ , text = %@", self.DrawingTool.class, text);
    if(([self.DrawingTool class] == [DrawingToolText  class]) && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    CGRect frame = self.textView.frame;
    if (self.textView.contentSize.height > frame.size.height) {
        frame.size.height = self.textView.contentSize.height;
    }
    
    self.textView.frame = frame;
}


#pragma mark - 键盘弹出事件
// 给键盘的事件添加监听
- (void)addNotificationToKeyboardAction
{
    NSLog(@"给键盘添加监听");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notify
{
    [self adjustIfTextViewHideByKeyboard:notify];
}

- (void)adjustIfTextViewHideByKeyboard:(NSNotification *)notify
{
    CGPoint textViewBottomPoint = [self convertPoint:self.textView.frame.origin toView:nil];
    textViewBottomPoint.y += self.textView.frame.size.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGSize keyboardSize = [[[notify userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat offset = (screenRect.size.height - keyboardSize.height) - textViewBottomPoint.y;
    
    if (offset < 0) {
        CGFloat newYPos = self.frame.origin.y + offset;
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);
        }];
    }
    
    NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
    
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    self.frame = originRect;
}

- (void)keyboardDidHide:(NSNotification *)notify
{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 滑动屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.textView && !self.textView.hidden) {
        [self textViewDidEndInput];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    cPoint = [touch locationInView:self];
    p2Point = [touch previousLocationInView:self];
    
    [self setupDrawTool];
    
    // 设置属性
    self.DrawingTool.lineWidth = self.lineWidth;
    self.DrawingTool.lineColor = self.lineColor;
    self.DrawingTool.lineAlpha = self.lineAlpha;
    
    if ([self.DrawingTool isKindOfClass:[DrawingToolText class]]) {
        [self initializeTextBoxWith:cPoint andMultiText:NO];
    } else {
        [self.DrawingTool setInitialPoint:cPoint];
        [self.pathArray addObject:self.DrawingTool];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    p1Point = p2Point;
    p2Point = [touch previousLocationInView:self];
    cPoint = [touch locationInView:self];

    if ([self.DrawingTool isKindOfClass:[DrawingToolPen class]]) {
        
        CGRect bounds = [(DrawingToolPen *)self.DrawingTool addPathFromPPreviousPoint:p1Point andPreviousPoint:p2Point andCurrentPoint:cPoint];
        CGRect drawBox = bounds;
        
        drawBox.origin.x -= self.DrawingTool.lineWidth*2;
        drawBox.origin.y -= self.DrawingTool.lineWidth*2;
        drawBox.size.width += self.DrawingTool.lineWidth*4;
        drawBox.size.height += self.DrawingTool.lineWidth*4;
        
        [self setNeedsDisplayInRect:drawBox];
    } else if ([self.DrawingTool isKindOfClass:[DrawingToolText class]]) {

        [self resizeTextViewFrame:CGPointMake(cPoint.x, cPoint.y)];
        
    } else {
        [self.DrawingTool movePointFrom:p2Point toPoint:cPoint];
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.DrawingTool isKindOfClass:[DrawingToolText class]]) {
        [self enterTextEdit];
    } else {
        [self touchesMoved:touches withEvent:event];    // 保证一个点也能绘图
        [self finishDrawing];
    }
}

#pragma mark - 系统方法
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.image drawAtPoint:CGPointZero];
    [self.DrawingTool draw];
}

// 初始化各种参数
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}


@end
