//
//  DrawingTool.m
//  DrawingViewDemo
//
//  Created by xxss0903 on 16/3/17.
//  Copyright © 2016年 rry.com. All rights reserved.
//

#import "DrawingTool.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

// 定义的计算两个点之间中点的方法,c
CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake(0.5*(p1.x+p2.x), 0.5*(p1.y+p2.y));
}

#pragma mark 画笔工具
@implementation DrawingToolPen

@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize lineAlpha = _lineAlpha;

- (instancetype)init
{
    if (self = [super init]) {
        path = CGPathCreateMutable();
        
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    
}

// 通过计算点之间的关系返回一个rect ？？？
- (CGRect)addPathFromPPreviousPoint:(CGPoint)p1Point andPreviousPoint:(CGPoint)p2Point andCurrentPoint:(CGPoint)cPoint
{
//    CGPoint mid1 = midPoint(p1Point, p2Point);
//    CGPoint mid2 = midPoint(p2Point, cPoint);
//    
//    CGMutablePathRef subPath = CGPathCreateMutable();
//    CGPathMoveToPoint(subPath, NULL, mid1.x, mid1.y);
//    CGPathAddQuadCurveToPoint(subPath, NULL, mid1.x, mid1.y, mid2.x, mid2.y);
//    CGRect bounds = CGPathGetBoundingBox(subPath);  // 获取subpath的rect
//    
//    CGPathAddPath(path, NULL, subPath); // 将子path添加到全局path中
//    CGPathRelease(subPath);
//    
//    return bounds;
    
    CGPoint mid1 = midPoint(p1Point, p2Point);
    CGPoint mid2 = midPoint(cPoint, p2Point);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, p1Point.x, p1Point.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(subpath);
    
    CGPathAddPath(path, NULL, subpath);
    CGPathRelease(subpath);
    
    return bounds;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);    // 添加path到context上
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGContextStrokePath(context);   // 将path渲染到context上
}

@end

@interface DrawingToolLine () <DrawingToolDelegate>

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end

#pragma mark 直线工具
#pragma mark -
@implementation DrawingToolLine
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    self.lastPoint = toPoint;
}

- (void)draw
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置线段属性
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // 绘制线段
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
}

@end

#pragma mark 橡皮擦
#pragma mark -
@implementation DrawingToolEraser

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

@end

#pragma mark 矩形
@interface DrawingToolRectangle ()

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end
#pragma mark -
@implementation DrawingToolRectangle
@synthesize lineAlpha = _lineAlpha;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    self.lastPoint = toPoint;
}

- (void)draw {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAlpha(context, self.lineAlpha);
    
    // 计算矩形
    CGRect rectangle = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    
    if (self.isFill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectangle);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectangle);
    }
}

@end

#pragma mark 箭头
@interface DrawingToolArrow ()

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end
#pragma mark -
@implementation DrawingToolArrow
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    self.lastPoint = toPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat capHeight = self.lineWidth * 4;
    
    // 设置属性
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    // 设置箭头曲线
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    // 绘制箭头帽
    CGFloat angle = [self angleWithFirstPoint:self.firstPoint andSecondPoint:self.lastPoint];
    CGPoint p1Point = [self pointWithAngle:angle+7.0f*M_PI/8.0f andDistant:capHeight];
    CGPoint p2Point = [self pointWithAngle:angle-7.0f*M_PI/8.0f andDistant:capHeight];
    CGPoint endPointOffset = [self pointWithAngle:angle andDistant:self.lineWidth];
    
    p1Point = CGPointMake(self.lastPoint.x+p1Point.x, self.lastPoint.y+p1Point.y);
    p2Point = CGPointMake(self.lastPoint.x+p2Point.x, self.lastPoint.y+p2Point.y);
    
    CGContextMoveToPoint(context, p1Point.x, p1Point.y);
    CGContextAddLineToPoint(context, endPointOffset.x+self.lastPoint.x, endPointOffset.y+self.lastPoint.y);
    CGContextAddLineToPoint(context, p2Point.x, p2Point.y);
    
    CGContextStrokePath(context);
}

- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    
    CGFloat angle = atan2f(dy, dx);
    
    
    return angle;
}

- (CGPoint)pointWithAngle:(CGFloat)angle andDistant:(CGFloat)distant
{
    CGFloat x = distant * cos(angle);
    CGFloat y = distant * sin(angle);
    
    return CGPointMake(x, y);
}


@end

#pragma mark 圆形
@interface DrawingToolOval ()

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end

#pragma mark -

@implementation DrawingToolOval
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    self.lastPoint = toPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置属性
    CGContextSetAlpha(context, self.lineAlpha);
    
    CGRect ovalRect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x-self.firstPoint.x, self.lastPoint.y-self.firstPoint.y);
        
    if (self.isFill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), ovalRect);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(context, ovalRect);
    }
}

@end

#pragma mark 文本
@interface DrawingToolText ()

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end
#pragma mark -
@implementation DrawingToolText
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize attributedText = _attributedText;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)movePointFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    self.lastPoint = toPoint;
}

- (void)draw
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the text
    CGRect viewBounds = CGRectMake(MIN(self.firstPoint.x, self.lastPoint.x),
                                   MIN(self.firstPoint.y, self.lastPoint.y),
                                   fabs(self.firstPoint.x - self.lastPoint.x),
                                   fabs(self.firstPoint.y - self.lastPoint.y)
                                   );
    
    // Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, 0, viewBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create a path which bounds the area where you will be drawing text.
    // The path need not be rectangular.
    CGMutablePathRef path = CGPathCreateMutable();
    
    // In this simple example, initialize a rectangular path.
    CGRect bounds = CGRectMake(viewBounds.origin.x, -viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    CGPathAddRect(path, NULL, bounds );
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    // Create a frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // Draw the specified frame in the given context.
    CTFrameDraw(frame, context);
    
    // Release the objects we used.
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
    CGContextRestoreGState(context);

//    
//    // 文本框
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 设置属性
//    CGContextSaveGState(context);
//    CGContextSetAlpha(context, self.lineAlpha);
//    
//    // 文本框的边框rect
//    CGRect textBounds = CGRectMake(MIN(self.firstPoint.x, self.lastPoint.x),
//                                   MIN(self.firstPoint.y, self.lastPoint.y),
//                                   fabs(self.lastPoint.x-self.firstPoint.x),
//                                   fabs(self.lastPoint.y-self.firstPoint.y)
//                                   );
//    CGContextTranslateCTM(context, 0, textBounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    
//    // 创建路径用来保存文本
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    CGRect bounds = CGRectMake(textBounds.origin.x, -textBounds.origin.y, textBounds.size.width, textBounds.size.height);
//    CGPathAddRect(path, NULL, bounds);
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
//    
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//    
//    CTFrameDraw(frame, context);
//    
//    CFRelease(frame);
//    CFRelease(framesetter);
//    CFRelease(path);
//    CGContextRestoreGState(context);
}

@end






















