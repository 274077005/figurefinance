//
//  DlgTFView.h
//  WEMEX
//
//  Created by 耿一 on 2018/3/17.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "DialogView.h"

@interface DlgTFView : DialogBase
SINGLETON_DECLARE(DlgTFView)


@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *affirmBtn;

@property (nonatomic,copy)CommBlock affirmBlock;
@property (nonatomic,copy)NSString* text;
@end
