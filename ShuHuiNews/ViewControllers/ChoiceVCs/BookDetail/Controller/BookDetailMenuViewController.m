//
//  BookDetailMenuViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/12.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "BookDetailMenuViewController.h"


@interface BookDetailMenuViewController ()
@property (nonatomic,strong) NSArray *dataAry;
@end

@implementation BookDetailMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _dataAry = @[@"一生一世",@"二两心思",@"三言两语",@"四海升平",@"五湖四海",@"六畜兴旺",@"七上八下",@"八仙过海",@"九牛一毛",@"十全十美",@"一生一世",@"二两心思",@"三言两语",@"四海升平",@"五湖四海",@"六畜兴旺",@"七上八下",@"八仙过海",@"九牛一毛",@"十全十美"];
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
    return _dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rank"];
    if (cell==nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rank"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",@(indexPath.row),_dataAry[indexPath.row]];
   
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row>5) {
        cell.detailTextLabel.text = @"购买";
         cell.textLabel.textColor= RGBCOLOR(166, 166, 166);
    }else{
        cell.detailTextLabel.text = @"试读";
         cell.textLabel.textColor= RGBCOLOR(30, 30, 30);
    }
    cell.detailTextLabel.textColor = RGBCOLOR(166, 166, 166);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *sortLb = [[UILabel alloc] initWithFrame:CGRectMake(16, 1, 100, 49)];
    sortLb.textColor = RGBCOLOR(30, 30, 30);
    sortLb.font = [UIFont systemFontOfSize:13];
    sortLb.text = @"章节排序";
    sortLb.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:sortLb];
    
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 15, 40, 20)];
    //CGPoint center = self.center;
    sortBtn.center = headerView.center;
    [sortBtn setTitle:@"正序" forState:UIControlStateNormal];
    [sortBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [sortBtn setTitleColor:RGBCOLOR(166, 166, 166) forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sortBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = RGBCOLOR(237, 237, 237);
    [headerView addSubview:line];
    return headerView;
}
- (void)sortBtnClicked:(UIButton *)sender{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
