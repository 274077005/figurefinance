//
//  OrderIntroView.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/2.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "OrderIntroView.h"

@implementation OrderIntroView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //[self initUI];
    }
    return self;
}

- (void)initUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"内容简介";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
    }];
    
    UILabel* detailLabel = [[UILabel alloc] init];
    detailLabel.text = @" 1、您将购买的商品为虚拟内容服务，购买后不支持退订、转让、退换，请斟酌确认 2、账户余额是指当前账户中的金豆总额，支付比例：1元=1金豆；3、购买后可在“我的已购”中查看作品；4、我的金豆可在我的钱包内查看";
    [self addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.offset(-20);
    }];
    
}

@end
