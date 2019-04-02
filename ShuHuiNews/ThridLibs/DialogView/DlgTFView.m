//
//  DlgTFView.m
//  WEMEX
//
//  Created by 耿一 on 2018/3/17.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "DlgTFView.h"

@implementation DlgTFView

//SINGLETON_IMPLEMENTATION(DlgTFView)
+(DlgTFView *)shared
{
    static DlgTFView* instance = nil;
    if (instance == nil) {
        instance = [[[NSBundle mainBundle] loadNibNamed:@"DlgTFView" owner:nil options:nil] lastObject];;
        
    }
    return instance;
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.8, 140);
    }
    
    return self;
}
- (void)setText:(NSString *)text {
    _textF.text = text;
    [_textF becomeFirstResponder];
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self close:^(id sender) {

    }];
}

- (IBAction)affirmBtnlick:(UIButton *)sender {
    [self close:^(id sender) {
        if (self.affirmBlock) {
            self.affirmBlock(_textF.text);
        }
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
