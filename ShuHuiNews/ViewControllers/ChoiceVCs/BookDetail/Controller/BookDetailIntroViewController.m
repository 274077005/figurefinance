//
//  BookDetailIntroViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/12.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "BookDetailIntroViewController.h"
#import "AuthorAutoCell.h"
#import "LableMessageCell.h"
@interface BookDetailIntroViewController ()



@end

@implementation BookDetailIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self createTableHeaderView];
   
}
- (void)createTableHeaderView
{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    tableHeader.backgroundColor = [UIColor whiteColor];
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    nameLb.textColor = RGBCOLOR(30, 30, 30);
    nameLb.font = kFont_Lable_15;
    [tableHeader addSubview:nameLb];
    nameLb.font = [UIFont boldSystemFontOfSize:15];
    nameLb.text = @"我是一条龙";
    self.tableView.tableHeaderView = tableHeader;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==3) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0||indexPath.section==1) {
        static NSString *const cid = @"cid";
        AuthorAutoCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
        if (!cell) {
            cell = [[AuthorAutoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        }
        if(indexPath.section==0)
        {
            
           [cell setContent:@" 平时我们用的第三方SDK基本上都是静态库。静态库在项目编译时完整地拷贝至可执行文件中，被多次使用就有多份冗余拷贝。静态库很大的一个优点是减少耦合性，因为静态库中是不可以包含其他静态库的，使用的时候要另外导入它的依赖库，最大限度的保证了每一个静态库都是独立的，不会重复引用。静态库有.a 和 .framework两种形式。"];
        }else{
            [cell setContent:@" 卢本伟 ，ID为Wh1t3zZ，1993年8月11日出生于香港，前皇族电子竞技俱乐部英雄联盟分部中单，在获得S3全球决赛亚军后退役。曾获2011TGA成都区冠军、2011TGA总决赛冠军、2011WCG中国区冠军、2013S3全球总决赛中国区冠军、2013S3全球总决赛亚军等荣誉。"];
        }
        return cell;
    }else if(indexPath.section == 2){
        static NSString *const labelCid = @"labelCid";
        LableMessageCell *cell = [tableView  dequeueReusableCellWithIdentifier:labelCid];
        if (!cell) {
            cell =[[LableMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCid];
        }
        cell.labelAry = @[@"有声读物",@"灵异",@"恐怖",@"短视频",@"悬疑",@"科幻"];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rank"];
        if (cell==nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rank"];
        }
        cell.textLabel.text = @"评论";
        cell.textLabel.textColor= [UIColor greenColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    NSString *text;
    if (section==0) {
        text = @"内容简介";
    }else if(section==1){
        text = @"作者简介";
    }else if (section==2){
        text = @"标签信息";
    }else{
        text = @"精彩评论";
    }
    lb.textColor = RGBCOLOR(30, 30, 30);
    lb.font = [UIFont boldSystemFontOfSize:15];
    lb.text = text;
    [header addSubview:lb];
    if(section==3){
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 20)];
        [commentBtn setTitle:@"立即评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:RGBCOLOR(35, 122, 229) forState:UIControlStateNormal];
        [commentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [commentBtn addTarget:self action:@selector(quickCommentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:commentBtn];
    }
    return header;
}
- (void)quickCommentBtnClicked:(UIButton *)btn
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.section==1) {
        CGFloat height = [AuthorAutoCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
        return height;
    }else{
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_VC.navigationController pushViewController:[NewSkipViewController new] animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
