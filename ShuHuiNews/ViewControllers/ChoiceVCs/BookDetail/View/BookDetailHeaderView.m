//
//  BookDetailHeaderView.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/19.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "BookDetailHeaderView.h"

@implementation BookDetailHeaderView
{
    UIImageView *_leftImg;
    UILabel *_bookNameLb;
    UILabel *_goldBeanLb;
    UIImageView *_headImg;
    UILabel *_authorLb;
    UIImageView *_categoryImg;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    CGFloat margin = 15;
    _leftImg = [[UIImageView alloc] init];
    _leftImg.frame = CGRectMake(margin, margin, 70, 90);
    [self addSubview:_leftImg];
    
    _bookNameLb = [[UILabel alloc] initWithFrame:CGRectMake(_leftImg.right+10, margin, SCREEN_WIDTH-25-70, 40)];
    _bookNameLb.lineBreakMode = NSLineBreakByWordWrapping; //根据单词进行换行
    //设置label显示几行  可以有无限行
    _bookNameLb.numberOfLines = 0;
    _bookNameLb.textColor = RGBCOLOR(40, 40, 40);
    _bookNameLb.textAlignment = NSTextAlignmentLeft;
    _bookNameLb.font = [UIFont boldSystemFontOfSize:15];
    
    [self addSubview:_bookNameLb];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(_bookNameLb.left, _leftImg.bottom-16, 16, 16)];
    [self addSubview:_headImg];
    
    _authorLb = [[UILabel alloc] initWithFrame:CGRectMake(_headImg.right+5, _headImg.top+3, 100, 13)];
    _authorLb.textColor = kFontGrayColor;
    _authorLb.font = kFont_Lable_12;
    [self addSubview:_authorLb];
    
    _goldBeanLb = [[UILabel alloc] initWithFrame:CGRectMake(_bookNameLb.left, _headImg.top-30, 100, 20)];
    _goldBeanLb.textColor = kFontGrayColor;
    _goldBeanLb.font = kFont_Lable_12;
    [self addSubview:_goldBeanLb];
    
    _categoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, _leftImg.bottom-10, 10, 10)];
    _categoryImg.image = [UIImage imageNamed:@"book_icon_gray"];
    [self addSubview:_categoryImg];
}
- (void)setDataAry:(NSArray *)dataAry
{
    _dataAry = dataAry;
    _leftImg.image = [UIImage imageNamed:@"rDHeader@3x.png"];
    _bookNameLb.text = @"《世纪三部曲（巨人的陨落+世界的凌动+永恒的边缘，全9册）》";
    _goldBeanLb.text = [NSString stringWithFormat:@"%@金豆",@"699"];
    _headImg.image = [UIImage imageNamed:@"shareWeChat@3x.png"];
    _authorLb.text = @"一生一世迷恋";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
