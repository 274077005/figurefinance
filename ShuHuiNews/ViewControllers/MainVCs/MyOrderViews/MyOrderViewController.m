//
//  MyOrderViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyBuyViewController.h"
#import "MyReadViewController.h"
#import "PlayerViewController.h"
#import "ChoiceBookDetailViewController.h"
#import "ChoiceVideoDetailViewController.h"
@interface MyOrderViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIView *buttonField;
@property (nonatomic,assign) NSInteger currentButton;
@property (nonatomic,assign) NSInteger oldButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *vcArray;
@property (nonatomic,strong) UIView *flag;


@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订购";
    [self setupScrollTitleView];
}
- (void)setupScrollTitleView{
    MyReadViewController *read = [[MyReadViewController alloc] init];
    read.title = @"我的订阅";
    
    MyBuyViewController *buy = [[MyBuyViewController alloc] init];
    buy.title = @"我的购买";
    
    
    self.vcArray = @[read,buy];
    [self initButtonFields];
    [self initMainView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"视频" style:UIBarButtonItemStyleDone target:self action:@selector(right)];
    UIBarButtonItem *bookItem = [[UIBarButtonItem alloc] initWithTitle:@"书籍" style:UIBarButtonItemStyleDone target:self action:@selector(book)];
    self.navigationItem.rightBarButtonItems= @[item,bookItem];
}
- (void)book{
    ChoiceBookDetailViewController *choice = [[ChoiceBookDetailViewController alloc] init];
    [self.navigationController pushViewController:choice animated:YES];
}
- (void)right{
    PlayerViewController *playerViewController = [[PlayerViewController alloc] init];
    
//    playerViewController.index = @"1";
//    playerViewController.url = [NSURL URLWithString:@"http://www.hmdata.com.cn/video/banner03.mp4"];
//    playerViewController.titleName = @"视频";
//    [self.navigationController pushViewController:playerViewController animated:YES];
    
    ChoiceVideoDetailViewController *video = [[ChoiceVideoDetailViewController alloc] init];
    video.url = @"http://www.hmdata.com.cn/video/banner03.mp4";
    [self.navigationController pushViewController:video animated:YES];
}
- (void)initButtonFields{
    _buttonField = [[UIView alloc] initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, 40)];
    _buttonField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonField];
    
    NSArray *titleArr = [self.vcArray valueForKeyPath:@"title"];
    NSArray *image = @[@"myread.png",@"mybuy.png"];
    NSArray *image_s = @[@"myread_s.png",@"mybug_s.png"];
    float buttonX = SCREEN_WIDTH/titleArr.count;
    for (int i=0; i<titleArr.count; i++) {
        NSString *title = titleArr[i];
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        [button setTitleColor:RGB(0xbcbcbc) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:image_s[i]] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        button.tag = 100+i;
        if (i==0) {
            self.currentButton = button.tag;
            button.selected = YES;
        }
        button.frame = CGRectMake(buttonX*i, 0, buttonX, 40.0);
        [button addTarget:self action:@selector(seletTableView:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonField addSubview:button];
    }
    //底部标记线
    _flag = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    _flag.backgroundColor = RGB(0xededed);
    [self.buttonField addSubview:_flag];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 10, 1, 20)];
    lineView.backgroundColor = RGB(0xededed);
    [self.buttonField addSubview:lineView];
}

- (void)initMainView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buttonField.frame)+2, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_buttonField.frame)+20.0)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(self.scrollView.frame));
    [self.vcArray enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:obj];
        [obj didMoveToParentViewController:self];
        obj.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, size.width, size.height);
        [self.scrollView  addSubview:obj.view];
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.vcArray.count, 0);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}
- (void)seletTableView:(UIButton *)button
{
    UIButton *lastButton = (UIButton *)[self.buttonField viewWithTag:self.currentButton];
    if (button.tag == self.currentButton) {
        return;
    }
    lastButton.selected = NO;
    self.currentButton = button.tag;
    [self updateViewController];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame  = weakSelf.flag.frame;
        frame.origin.x = button.origin.x;
//        weakSelf.flag.frame = frame;
    }];
}
- (void)updateViewController{
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(int)(self.currentButton%100), 0);
}
#pragma mark 0 UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffX = scrollView.contentOffset.x;
    CGFloat startOffX   = scrollView.frame.size.width*(self.currentButton - 100);
    float rate = 0;
    if(contentOffX > startOffX){
        rate = contentOffX/scrollView.frame.size.width;
    }else{
        rate = contentOffX/scrollView.frame.size.width;
    }
    UIButton *lastButton = (UIButton *)[self.buttonField viewWithTag:self.currentButton];
    float rate1 = roundf(rate);
    self.currentButton = rate1+100;
    UIButton *currentClickButton = (UIButton *)[self.buttonField viewWithTag:self.currentButton];
    lastButton.selected = NO;
    currentClickButton.selected = !currentClickButton.selected;
    __weak typeof(self) wkSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frm = wkSelf.flag.frame;
        frm.origin.x  = lastButton.frame.origin.x;
//        wkSelf.flag.frame = frm;
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollView == scrollView) {
        self.oldButton = self.currentButton;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView == scrollView) {
        if (self.oldButton != self.currentButton) {
            [self updateViewController];
        }
    }
    
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
