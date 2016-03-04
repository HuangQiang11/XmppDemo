//
//  HQXMPPManager.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQXMPPManager.h"

@implementation HQXMPPManager
static HQXMPPManager * manager;

+(HQXMPPManager *)shareXMPPManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[HQXMPPManager alloc] init];
    });
    return manager;
}

#pragma mark common method
- (void)xmppUserLoginWithResult:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    self.registerOperation = NO;
    [_xmppStream disconnect];
    [self connectToHost];
}

- (void)xmppUserlogoutWithResult:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];                                              // " 发送 "离线" 消息"
    [_xmppStream disconnect];                                                       //  与服务器断开连接
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = NO;                            //  更新用户的登录状态
}

- (void)xmppUserRegisterWithResutl:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    self.registerOperation = YES;
    [_xmppStream disconnect];
    [self connectToHost];                                                           // 连接主机 成功后发送注册密码
}

#pragma mark private method
-(void)connectToHost{
    DLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [HQXMPPUserInfo shareXMPPUserInfo].registerUser;
    }else{
        user = [HQXMPPUserInfo shareXMPPUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:kDOMAIN resource:@"iphone" ];
    
    [HQXMPPUserInfo shareXMPPUserInfo].user=user;
    
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = kHOSTNAME;                                   //不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        DLog(@"%@",err);
    }
    
}

-(void)sendPwdToHost{
    DLog(@"再发送密码授权");
    NSError *err = nil;
    NSString *pwd = [HQXMPPUserInfo shareXMPPUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        DLog(@"%@",err);
    }
}

-(void)sendOnlineToHost{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    //#warning 每一个模块添加后都要激活
    
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    [_msgArchiving setClientSideMessageArchivingOnly:YES];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    [_avatar addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

-(void)teardownXmpp{
    // 移除代理
    [_xmppStream removeDelegate:self];
    // 停止模块
    [_reconnect deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    // 清空资源
    _reconnect = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    
}

#pragma mark -XMPPStream delegate

//与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    DLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {                                                     //注册操作，发送注册的密码
        NSString *pwd = [HQXMPPUserInfo shareXMPPUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{                                                                              //登录操
        [self sendPwdToHost];                                                           // 主机连接成功后，发送密码进行授权
    }
    
}

//与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }else if (error == nil && _resultBlock){
        _resultBlock(XMPPResultTypeLogoutSuccess);
    }
    
    DLog(@"与主机断开连接 %@",error);
    
}

//授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DLog(@"授权成功");
    [self sendOnlineToHost];                                                    //登陆成功发送在线消息
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = YES;
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);                               //执行登陆成功的操作
    }
    
}


//授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    DLog(@"授权失败 %@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);                               //执行登陆失败的操作
    }
}

//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    DLog(@"注册成功");
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = YES;
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);                            //执行注册成功的操作
    }
    
}

//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    DLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);                            //执行注册失败的操作
    }
    
}

//iQ
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}

//接收到好友消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    DLog(@"++++++++++xmppstream didreceivemessage+++++++++++++++++%@",message);
//    if([message isMessageWithBody]){
//        if ([message.type isEqual:@"groupchat"]) {
//            if ([HQXMPPUserInfo shareXMPPUserInfo].joinRoomName != nil && ![[HQXMPPUserInfo shareXMPPUserInfo].joinRoomName isEqual:@""] &&[ [message fromStr] hasPrefix:[HQXMPPUserInfo shareXMPPUserInfo].joinRoomName]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGroupChatMessage object:message];
//            }
//        }
//    }
}

//send message Fail
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    DLog(@"%@",error);
}

//receive presence
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    DLog(@"didReceivePresence");
    DLog(@"%@",presence);
    //receive remove friend message
    if ([presence.type isEqual:@"unsubscribed"]) {
        [_roster removeUser:presence.from];
    }
}

#pragma mark XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //receive add friend message
    DLog(@"didReceivePresenceSubscriptionRequest:%@",presence);
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [presence fromStr]];
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [_roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)dealloc{
    [self teardownXmpp];
}

@end
