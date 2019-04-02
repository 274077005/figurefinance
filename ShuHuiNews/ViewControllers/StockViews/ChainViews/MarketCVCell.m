//
//  HomeCVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MarketCVCell.h"

@implementation MarketCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)createContentView
{

//    if ([_theId isEqualToString:@"6"]) {
//        self.flashV.theId = _theId;
//    }else{
//        self.recommendV.theId = _theId;
//    }
    self.listV.theId = _theId;

    
//    [self.contentView addSubview:self.newsV];
}
-(void)getData
{
    [self.listV getListData];
}

- (UIView *)listV
{
    if (!_listV) {
        _listV = [[MarketListV alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_listV];
        
    }
    return _listV;
}
- (void)dealloc{
    NSLog(@"aaaaaaaaaaaaa");
}


@end
