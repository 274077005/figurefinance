//
//  CalendarVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CalendarVC.h"

@interface CalendarVC ()
{

    NSMutableArray * _calendarArr;
    //完整的日期数组，用来请求数据
    NSMutableArray * _wholeCaArr;
    NSMutableArray * _weekDayArr;
    NSMutableArray * _buttonArr;
    NSMutableArray * _itemWithArray;
    NSMutableArray * _itemInfoArray;
    
    NSMutableArray * _dataArr;
    //获取数据的时间
    NSString * _dayStr;
    //记录滚动视图的长度
    float _totalWidth;
}

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _calendarArr = [[NSMutableArray alloc]init];
    _wholeCaArr = [[NSMutableArray alloc]init];
    
    _weekDayArr = [[NSMutableArray alloc]init];
    
    _dataArr = [[NSMutableArray alloc]init];
    [self createTableView];
    [self setUpTableView];
    [self calculateCalendarData];
    [self getCalendarData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getCalendarData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:@"IOS" forKey:@"app"];
    [bodyDic setObject:@"Jin10qwertyhb77uj8ukl8i" forKey:@"password"];
    [bodyDic setObject:@"GetRiliListRequest" forKey:@"method"];
    [bodyDic setObject:@"" forKey:@"sessionId"];
    NSDictionary *startDic = [NSDictionary dictionaryWithObjectsAndKeys:_dayStr,@"start",nil];
    NSDictionary *whereDic = [NSDictionary dictionaryWithObjectsAndKeys:startDic,@"wheres",@"1000",@"limit",nil];

    [bodyDic setObject:whereDic forKey:@"jsonStr"];
    
    NSMutableDictionary * postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:bodyDic,@"bodyDic",@"https://sshibiddce.jin10.com:4431/",@"postUrl",nil];
    
    [GYPostData PostCalendarWithDic:postDic UrlPath:JCalendarList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            if ([jsonDic[@"status_code"] integerValue] == 200) {
                NSArray * modelArr = [CalendarModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
                [self calculateCellHeightWithArr:modelArr];
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:modelArr];
                if (_dataArr.count == 0) {
                    [SVProgressHUD showWithString:@"该日期无数据哦~"];
                }
                [self.tableView reloadData];
            }
        }
    }];
}
- (void)calculateCellHeightWithArr:(NSArray *)array
{
    
    for (CalendarModel * caModel in array) {

            caModel.cellHeight = [GYToolKit AttribLHWithSpace:5 size:15 width:SCREEN_WIDTH - 140 str:caModel.title] + 70;
        
    }
}
-(void)calculateCalendarData
{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger second = [[NSString stringWithFormat:@"%f",time] integerValue];
    
    NSInteger previousSecond = second - 16 * 86400;


    NSArray * weekArr = @[@"哈哈",@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    for (NSInteger i = 1; i <= 30; i++) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:previousSecond + i * 86400];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
//        yyyy-MM-dd HH:mm:ss
        [dateFormatter setDateFormat:@"dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [_calendarArr addObject:currentDateStr];
        
        NSDateFormatter *wholeFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        //        yyyy-MM-dd HH:mm:ss
        [wholeFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *wholeDateStr = [wholeFormatter stringFromDate:date];
        [_wholeCaArr addObject:wholeDateStr];
        
        //获取周几下标
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *weekdayComponents =
        [gregorian components:NSCalendarUnitWeekday fromDate:date];
        NSInteger weekday = [weekdayComponents weekday];
        [_weekDayArr addObject:weekArr[weekday]];

    }
    [self createMenuScrollView];
}
//创建菜单上的按钮
-(void)createMenuScrollView
{
    [self.menuScrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _itemWithArray = [[NSMutableArray alloc] init];
    
    
    _itemInfoArray = [[NSMutableArray alloc] init];
    _buttonArr = [[NSMutableArray alloc] init];
    
    //创建其他的市场按钮
    float menuWidth = 0.0;
    NSInteger itemWidth = 62.5;
    for (int i = 0;i<_calendarArr.count; i++) {
        
        
        UILabel * weekLab = [[UILabel alloc]initWithFrame:CGRectMake(menuWidth, 5, itemWidth, 30)];
        weekLab.font = [UIFont systemFontOfSize:14];
        weekLab.textColor = RGBCOLOR(71, 71, 71);
        weekLab.textAlignment = NSTextAlignmentCenter;
        weekLab.text = _weekDayArr[i];
        [self.menuScrollV addSubview:weekLab];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(menuWidth, 0, 26, 26);
        [button setTitle:_calendarArr[i] forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(71, 71, 71) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(35,122,229) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor clearColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.width/2;
        button.layer.borderColor = RGBCOLOR(35,122,229).CGColor;
        button.center = CGPointMake(weekLab.center.x, weekLab.bottom + button.width/2);
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        if (i == _calendarArr.count/2) {
            button.selected = YES;
            button.backgroundColor = RGBCOLOR(222, 239, 251);
            button.layer.borderWidth = 0.5;
            _dayStr = _wholeCaArr[i];
        }
        
        [self.menuScrollV addSubview:button];
        [_itemInfoArray addObject:@(menuWidth)];
        menuWidth += itemWidth;
        
        [_buttonArr addObject:button];
        [_itemWithArray addObject:@(itemWidth)];
    }
    
    _totalWidth = menuWidth;
    [self.menuScrollV setContentSize:CGSizeMake(menuWidth, 30)];

    self.menuScrollV.contentOffset = CGPointMake(menuWidth/2 - itemWidth * 3 , 0);
 
}
#pragma mark - ScrollView点击事件
- (void)menuButtonClicked:(UIButton *)btn {
    [self changeButtonStateAtIndex:btn.tag];
    
    _dayStr = _wholeCaArr[btn.tag];
    [self getCalendarData];
 
}


//改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index {
    
    UIButton *button = [_buttonArr objectAtIndex:index];
    [self changeButtonsToNormalState];
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    button.selected = YES;
    button.backgroundColor = RGBCOLOR(222, 239, 251);
    button.layer.borderWidth = 0.5;
    if (index !=0) {
        [self moveMenuVAtIndex:index];
    }
    
}

//取消所有button点击状态
-(void)changeButtonsToNormalState {
    for (UIButton *btn in _buttonArr) {
        btn.selected = NO;
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderWidth = 0;
    }
}

//移动button到可视的区域
- (void)moveMenuVAtIndex:(NSInteger)index {
    if (_itemInfoArray.count < index) {
        return;
    };
    //宽度小于320肯定不需要移动
    CGFloat Width = _menuScrollV.frame.size.width;
    if (_totalWidth <= Width) {
        return;
    }
    float buttonOrigin = [_itemInfoArray[index] floatValue];
    if (buttonOrigin >= Width - 180) {
        if ((buttonOrigin - 180) >= _menuScrollV.contentSize.width - Width) {
            [_menuScrollV setContentOffset:CGPointMake(_menuScrollV.contentSize.width - Width, _menuScrollV.contentOffset.y) animated:YES];
            return;
        }
        
        float moveToContentOffset = buttonOrigin - 180;
        if (moveToContentOffset > 0) {
            [_menuScrollV setContentOffset:CGPointMake(moveToContentOffset, _menuScrollV.contentOffset.y) animated:YES];
            
        }
    }else{
        [_menuScrollV setContentOffset:CGPointMake(0, _menuScrollV.contentOffset.y) animated:YES];
        
        return;
    }
}
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, TopHeight + 75, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight - TopHeight - 75);
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"CalendarTVCell" bundle:nil] forCellReuseIdentifier:@"CaCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCalendarData)];

    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

//    if (_dataArr.count < 1) {
//        return 0;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return _dataArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarModel * caModel = _dataArr[indexPath.row];
    return caModel.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CalendarTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CaCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.caModel = _dataArr[indexPath.row];
    [cell updateWithModel];
    return cell;
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
