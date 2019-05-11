//
//  RDWorksCell.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDWorksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *booksImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;

@property (strong,nonatomic) HomeAuthorModel *worksModel;

- (void)setWorksModel:(HomeAuthorModel * _Nonnull)worksModel;

@end



NS_ASSUME_NONNULL_END
