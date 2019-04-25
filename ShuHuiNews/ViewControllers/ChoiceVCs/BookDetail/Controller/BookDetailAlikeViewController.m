//
//  BookDetailAlikeViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/12.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "BookDetailAlikeViewController.h"
#import "MediaItemModel.h"
#import "MediaItemCell.h"

@interface BookDetailAlikeViewController ()
{
    GetDataType _getDataType;
    NSInteger _index;
}
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation BookDetailAlikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self initDataAry];
   
}
-(void)initDataAry{
    _dataAry = [[NSMutableArray alloc] init];
    //测试用的
    for (int i=0; i<10; i++) {
        MediaItemModel *model = [[MediaItemModel alloc] init];
        [_dataAry addObject:model];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cid = @"MyReadCid";
    MediaItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[MediaItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    MediaItemModel *data = self.dataAry[indexPath.row];
    cell.model = data;
    cell.cancelButtonClickedBlock = ^{
//        [self cancelReadWith:data index:indexPath];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [_VC.navigationController pushViewController:[NewSkipViewController new] animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
