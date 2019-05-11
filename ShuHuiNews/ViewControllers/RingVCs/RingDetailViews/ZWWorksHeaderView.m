//
//  ZWWorksHeaderView.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "ZWWorksHeaderView.h"
#import "ZWWorksListViewController.h"

@implementation ZWWorksHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    if(_worksList.count!=0){
        self.noInfoLabel.hidden = YES;
    }
    
}

- (IBAction)clickMoreButton:(id)sender {
    ZWWorksListViewController *worksList = [[ZWWorksListViewController alloc] init];
    
    [self.viewContoller.navigationController pushViewController:worksList animated:YES];
    
}
@end
