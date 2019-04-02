//
//  PlayerViewController.h
//  video
//
//  Created by zzw on 2017/1/13.
//  Copyright © 2017年 zzw. All rights reserved.
//

#define DEVICE_TYPE_IPAD  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
@property (nonatomic,copy)NSString * index;
@property (nonatomic,strong)NSURL *url;
@property (nonatomic,copy)NSString * titleName;

@end
