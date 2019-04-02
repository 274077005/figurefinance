//
//  NewAndFixCollectionViewCell.h
//  video
//
//  Created by zzw on 2017/1/12.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAndFixCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

- (void)updateWith;
@end
