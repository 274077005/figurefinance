//
//  Categorys.m
//  NewLife
//
//  Created by Zach on 15-8-25.
//  Copyright (c) 2015年 WEMEX. All rights reserved.
//

#import "Categorys.h"
#import <objc/runtime.h>

@implementation UIView (Postion)
-(CGFloat)fx {return self.frame.origin.x;}
-(CGFloat)fy {return self.frame.origin.y;}
-(CGFloat)fw {return self.frame.size.width;}
-(CGFloat)fh {return self.frame.size.height;}
-(CGPoint)fp {return self.frame.origin;}
-(CGSize)fs {return self.frame.size;}

-(CGFloat)cx {return self.center.x;}
-(CGFloat)cy {return self.center.y;}
-(CGFloat)ex {return self.frame.origin.x + self.frame.size.width;}
-(CGFloat)ey {return self.frame.origin.y + self.frame.size.height;}


-(void)setFx:(CGFloat)fx {CGRect frame=self.frame;frame.origin.x=fx;self.frame=frame;}
-(void)setFy:(CGFloat)fy {CGRect frame=self.frame;frame.origin.y=fy;self.frame=frame;}
-(void)setFw:(CGFloat)fw {CGRect frame=self.frame;frame.size.width=fw;self.frame=frame;}
-(void)setFh:(CGFloat)fh {CGRect frame=self.frame;frame.size.height=fh;self.frame=frame;}
-(void)setFp:(CGPoint)fp {self.fx=fp.x; self.fy=fp.y;}
-(void)setFs:(CGSize)fs {self.fw=fs.width; self.fh=fs.height;}

-(void)setCx:(CGFloat)cx {CGPoint p=self.center;p.x=cx;self.center=p;}
-(void)setCy:(CGFloat)cy {CGPoint p=self.center;p.y=cy;self.center=p;}
-(void)setEx:(CGFloat)ex {CGRect frame=self.frame;frame.origin.x=ex-frame.size.width;self.frame=frame;}
-(void)setEy:(CGFloat)ey {CGRect frame=self.frame;frame.origin.y=ey-frame.size.height;self.frame=frame;}
@end



@implementation UIView (AppExtension)

- (UIViewController *)viewContoller {
    UIView* superView = self.superview;
    while (superView)
    {
        UIResponder *nextResponder = [superView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)nextResponder;
        else
            superView = superView.superview;
    }
    return nil;
}

- (CGPoint)convertXYToView:(UIView *)view {
    return [self convertPoint:CGPointZero toView:view];
}

- (id)addSubviewEx:(UIView *)view {
    [self addSubview:view];
    return view;
}

- (UIView*)parentByClass:(Class)parentClass {
    UIView* superView = self.superview;
    while ( superView!=nil ) {
        if ( [superView isKindOfClass:parentClass] ) {
            return (UIView*)superView;
        }
        superView = superView.superview;
    }
    return nil;
}

@end

@implementation UIView (OPCloning)
- (id)clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}
@end

@implementation UIImage (AppExtension)

- (CGFloat)sw{ return self.size.width; }

- (CGFloat)sh{ return self.size.height; }

@end

@implementation UIImageView (AppExtension)

- (UIEdgeInsets)capInsets { return UIEdgeInsetsZero; }

- (void)setCapInsets:(UIEdgeInsets)capInsets {
    self.image = [self.image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

@end

@implementation UIAlertView (Block)
static char key;
id oldDelegate = nil;

- (void)showWithBlock:(UIAlertViewButtonClick)block
{
    if (block) {
        //移除所有关联
        objc_removeAssociatedObjects(self);
        //创建关联
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        oldDelegate = self.delegate;
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //获取关联的对象，通过关键字。
    UIAlertViewButtonClick block = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    if ([oldDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [oldDelegate performSelector:@selector(willPresentAlertView:) withObject:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
{
    if ([oldDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [oldDelegate performSelector:@selector(didPresentAlertView:) withObject:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    if ([oldDelegate respondsToSelector:@selector(alertView: didDismissWithButtonIndex:)]) {
        [oldDelegate performSelector:@selector(alertView: didDismissWithButtonIndex:) withObject:alertView withObject:nil];
    }
}

@end



@implementation UIButton (VerticalLayout)

-(NSDictionary *)paramDic{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setParamDic:(NSDictionary *)paramDic{
    objc_setAssociatedObject(self, @selector(paramDic), paramDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)centerVerticallyWithPadding:(float)padding
{
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes: @{NSFontAttributeName:self.titleLabel.font}];
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    
}

- (void)centerVertically
{
    const CGFloat kDefaultPadding = 6.0f;
    [self centerVerticallyWithPadding:kDefaultPadding];
}  
@end



@implementation UILabel (AppExtension)

- (CGSize) textSize {
    CGSize size = [self.text boundingRectWithSize: CGSizeMake(self.frame.size.width, 2000)
                                          options: NSStringDrawingUsesLineFragmentOrigin
                                       attributes: @{NSFontAttributeName:self.font}
                                          context: nil].size;
    return size;
}

- (void)setAttributedTexts:(NSArray *)attributedTexts {
    NSMutableString* text = [NSMutableString string];
    for (NSDictionary* item in attributedTexts) {
        [text appendString:item[NSAttrText]];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSDictionary* txtCfg in attributedTexts) {
        if ( isNullStr(txtCfg[NSAttrText]) ) {
            continue;
        }
        NSMutableDictionary* value = [txtCfg mutableCopy];
        [value removeObjectForKey:NSAttrText];
        NSArray* rangeList = [text rangesOfString:txtCfg[NSAttrText]];
        for (id rangeObj in rangeList) {
            [attrString addAttributes:value range:[rangeObj rangeValue]];
        }
    }
    self.attributedText = attrString;
}

- (NSArray*) attributedTexts {
    return nil;
}


@end


@implementation NSString(AppExtension)

- (NSArray *)rangesOfString:(NSString *)substring {
    NSError *error = NULL;
    NSString *regex = [substring stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    regex = [regex stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    regex = [regex stringByReplacingOccurrencesOfString:@"|" withString:@"\\|"];
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray *ranges = [NSMutableArray array];
    NSArray *matches = [regExpression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *match in matches) {
        [ranges addObject:[NSValue valueWithRange:match.range]];
    }
    return ranges;
}

@end



