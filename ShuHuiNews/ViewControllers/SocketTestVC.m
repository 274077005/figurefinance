//
//  SocketTestVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/2.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SocketTestVC.h"

@interface SocketTestVC ()
{
    NSTimer * _heartTimer;
}

@end

@implementation SocketTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJinShiData];

}
- (IBAction)createSocketBtnClick:(UIButton *)sender {
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://m.fxmust.com/economicCalendar"]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getJinShiData
{

}
//初始化心跳
- (void)initHeartBeat
{


        dispatch_main_async_safe(^{
            [self destoryHeartBeat];
            //心跳设置为3分钟，NAT超时一般为5分钟
            _heartTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sendHeart) userInfo:nil repeats:YES];

            
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:NSRunLoopCommonModes];
        })
    

}
- (void)sendHeart
{
    NSLog(@"-----pong");
    [_webSocket send:@"00000000"];
}
//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (_heartTimer) {
            if ([_heartTimer respondsToSelector:@selector(isValid)]){
                if ([_heartTimer isValid]){
                    [_heartTimer invalidate];
                    _heartTimer = nil;
                }
            }
        }
    })
}
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
    NSString * dateStr = [GYToolKit getTimeIntervalSince1970];
    NSDictionary * sendDic = @{@"code":@"EC004",@"data":@{@"date":dateStr}};
    NSString * sendStr = [GYToolKit dictionaryToJsonStr:sendDic];
    NSLog(@"%@",sendStr);
    [webSocket send:sendStr];

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    NSString *str2 = [NSString stringWithFormat:@"%@",message];
    NSLog(@"%@",str2);
    [self initHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@",reason);
    self.title = @"Connection Closed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"Reply:%@",reply);
}

// 发送数据
- (IBAction)sendMessageAction:(id)sender{

    
}


@end
