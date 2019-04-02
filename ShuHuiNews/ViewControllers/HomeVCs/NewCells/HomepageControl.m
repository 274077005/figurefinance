//
//  HomepageControl.m
//  Treasure
//
//  Created by Viptail on 2017/6/1.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "HomepageControl.h"

@implementation HomepageControl

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dotH = 3;
        
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//
//    }
//    return self;
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //宽高和间距
    //    CGFloat dotW = 40;
    CGFloat dotW = (SCREEN_WIDTH/1.1)/self.subviews.count;

    CGFloat magrin = 0;
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count) * marginX;
    
    if (!isnan(newW)) {
        //设置新frame
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    }
    
    //设置居中
    CGPoint center = self.center;

    center.x = self.superview.width/2;
    self.center = center;
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * marginX, self.height - self.dotH, dotW, self.dotH)];
        //添加imageV
        
        
        if ([dot.subviews count] == 0) {
            UIImageView * view = [[UIImageView alloc]initWithFrame:dot.bounds];
            [dot addSubview:view];
        };
        
        if (i == self.currentPage) {
            UIImageView * imageV = dot.subviews[0];
            imageV.backgroundColor = RGBCOLOR(14, 124, 244);

            
        }else {
            UIImageView * imageV = dot.subviews[0];
            imageV.backgroundColor = [UIColor clearColor];

        }
    }
}
//-(id) initWithFrame:(CGRect)frame
//
//{
//
//    self = [super initWithFrame:frame];
//
//
//    activeImage = [UIImage imageNamed:@"home"] ;
//
//    inactiveImage = [UIImage imageNamed:@"news"];
//
//
//    return self;
//
//}
//
//
-(void) updateDots

{
    
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        CGSize size;
        
        size.height = 5;     //自定义圆点的大小
        
        size.width = 5;      //自定义圆点的大小
        
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.height)];
        if (i == self.currentPage){
            dot.backgroundColor = [UIColor blueColor];
        }
        else{
            dot.backgroundColor = [UIColor redColor];
        }
        
    }
    
    
    
}
//
//-(void) setCurrentPage:(NSInteger)page
//
//{
//
//    [super setCurrentPage:page];
//
//    [self updateDots];
//
//}
@end

