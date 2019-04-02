//
//  Categorys.h
//  NewLife
//
//  Created by Zach on 15-8-25.
//  Copyright (c) 2015年 WEMEX. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -- UIVIew Categorys --
@interface UIView (Postion)
@property(nonatomic,assign)CGFloat fx;
@property(nonatomic,assign)CGFloat fy;
@property(nonatomic,assign)CGFloat fw;
@property(nonatomic,assign)CGFloat fh;
@property(nonatomic,assign)CGFloat cx;
@property(nonatomic,assign)CGFloat cy;
@property(nonatomic,assign)CGFloat ex;
@property(nonatomic,assign)CGFloat ey;
@property(nonatomic,assign)CGPoint fp;
@property(nonatomic,assign)CGSize  fs;
@end


@interface UIView (AppExtension)
@property(nonatomic, weak, readonly)UIViewController* viewContoller;
- (CGPoint)convertXYToView:(UIView *)view;
- (id)addSubviewEx:(UIView *)view;
- (UIView*)parentByClass:(Class)parentClass;
@end

@interface UIView (OPCloning)
- (id)clone;
@end

@interface UIImage (AppExtension)
@property(nonatomic,assign, readonly)CGFloat sw;
@property(nonatomic,assign, readonly)CGFloat sh;
@end

@interface UIImageView (AppExtension)
@property(nonatomic,assign)UIEdgeInsets capInsets;
@end

#pragma mark -- UIAlertView Categorys --
typedef void(^UIAlertViewButtonClick) (NSInteger btnIndex);
@interface UIAlertView (Block)<UIAlertViewDelegate>
- (void)showWithBlock:(UIAlertViewButtonClick)block;
@end


#pragma mark -- UIButton Categorys --
@interface UIButton (VerticalLayout)
@property (strong ,nonatomic) NSDictionary *paramDic;
- (void)centerVerticallyWithPadding:(float)padding;
- (void)centerVertically;
@end



// UILABEL NSAttributedStringKey
#define NSAttrText              @"NSTextAttributeName"
#define NSAttrColor             NSForegroundColorAttributeName
#define NSAttrFont              NSFontAttributeName
#define isNullStr(x)        ( ((x)==nil) || [(x) isEqual:[NSNull null]] || [(x) isEqualToString:@""])
// 字体定义
#define UIFontEx(s, w)      ([UIFont systemFontOfSize:s])
#define FontUL(s)           UIFontEx(s, UIFontWeightUltraLight)
#define FontT(s)            UIFontEx(s, UIFontWeightThin)
#define FontL(s)            UIFontEx(s, UIFontWeightLight)
#define FontR(s)            UIFontEx(s, UIFontWeightRegular)
#define FontM(s)            UIFontEx(s, UIFontWeightMedium)
#define FontS(s)            UIFontEx(s, UIFontWeightSemibold)
#define FontBo(s)           UIFontEx(s, UIFontWeightBold)
#define FontH(s)            UIFontEx(s, UIFontWeightHeavy)
#define FontBl(s)           UIFontEx(s, UIFontWeightBlack)
#define Font(s)             FontR(s)

@interface UILabel(AppExtension)

@property (nonatomic, assign, readonly)CGSize textSize;

@property (nonatomic)NSArray* attributedTexts;

@end

@interface NSString(AppExtension)

- (NSArray *)rangesOfString:(NSString *)substring;

@end

@interface NSArray(AppMutable)

- (NSMutableArray*)deepMutable;

@end

