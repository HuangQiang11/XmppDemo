//
//  HQXMPPManager.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "DLog.h"
#import "HQXMPPUserInfo.h"
#import "config.h"

#define ReceiveGroupChatMessage @"groupChatMessage"

typedef enum {
    XMPPResultTypeConnecting,                           //连接中...
    XMPPResultTypeLoginSuccess,                         //登录成功
    XMPPResultTypeLoginFailure,                         //登录失败
    XMPPResultTypeNetErr,                               //网络不给力
    XMPPResultTypeRegisterSuccess,                      //注册成功
    XMPPResultTypeRegisterFailure,                      //注册失败
    XMPPResultTypeLogoutSuccess                         //登出成功
}XMPPResultType;

typedef void (^XMPPResultBlock)(XMPPResultType type);
@interface HQXMPPManager : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>{
    XMPPResultBlock _resultBlock;
    
    XMPPReconnect *_reconnect;                             // 自动连接模块
    
    XMPPMessageArchiving *_msgArchiving;                   // 消息归档模块
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
}

@property (nonatomic, strong,readonly)XMPPStream *xmppStream;
@property (nonatomic, strong,readonly)XMPPMessageArchivingCoreDataStorage *msgStorage;     //消息归档数据库
@property (nonatomic, strong,readonly)XMPPRoster *roster;                                  //花名册模块
@property (nonatomic, strong,readonly)XMPPRosterCoreDataStorage *rosterStorage;            //花名册储存模块
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;          //注册操作
@property (nonatomic, strong,readonly)XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong,readonly)XMPPvCardAvatarModule * avatar;//头像模块

+(HQXMPPManager *)shareXMPPManager;
- (void)xmppUserlogoutWithResult:(XMPPResultBlock)resultBlock;
- (void)xmppUserLoginWithResult:(XMPPResultBlock)resultBlock;            //user login
- (void)xmppUserRegisterWithResutl:(XMPPResultBlock)resultBlock;         //user regist
@end
