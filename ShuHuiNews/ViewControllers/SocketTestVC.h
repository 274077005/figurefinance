//
//  SocketTestVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/2.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "SRWebSocket.h"
@interface SocketTestVC : BaseViewController <SRWebSocketDelegate>

@property (strong, nonatomic) SRWebSocket * webSocket;

@property (assign, nonatomic) BOOL connected;
@end
