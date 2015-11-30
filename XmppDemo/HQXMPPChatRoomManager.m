//
//  HQChatRoomManager.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQXMPPChatRoomManager.h"

@implementation HQXMPPChatRoomManager

static HQXMPPChatRoomManager * manager;
+ (HQXMPPChatRoomManager *)shareChatRoomManager{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        manager = [[HQXMPPChatRoomManager alloc] init];
        [manager setup];
    });
    return manager;
}

#pragma mark private method
- (void)setup{
    self.roomList = [NSMutableArray array];
    muc=[[XMPPMUC alloc] init];
    [muc activate:[HQXMPPManager shareXMPPManager].xmppStream];
    [muc addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(NSXMLElement *)configNewRoom:(XMPPRoom *)room{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    NSXMLElement *p;
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];//永久房间
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_maxusers"];//最大用户
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"10"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_changesubject"];//允许改变主题
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_publicroom"];//公共房间
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_allowinvites"];//允许邀请
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field"];
    [p addAttributeWithName:@"var" stringValue:@"muc#maxhistoryfetch"];
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"100"]]; //history
    [x addChild:p];
    
    /*
     p = [NSXMLElement elementWithName:@"field" ];
     [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomname"];//房间名称
     [p addChild:[NSXMLElement elementWithName:@"value" stringValue:self.roomTitle]];
     [x addChild:p];
     
     p = [NSXMLElement elementWithName:@"field" ];
     [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_enablelogging"];//允许登录对话
     [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
     [x addChild:p];
     */
    return x;
}


#pragma mark common method
- (void)queryRooms{
    [muc discoverRoomsForServiceNamed:[NSString stringWithFormat:@"muc.%@",kDOMAIN]];
}

- (void)creatChatRoom:(NSString *)roomJid{
    XMPPRoomMemoryStorage *roomStorage = [[XMPPRoomMemoryStorage alloc] init];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomJid];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom activate:[HQXMPPManager shareXMPPManager].xmppStream];
    [xmppRoom addDelegate:self
            delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:[HQXMPPUserInfo shareXMPPUserInfo].user
                            history:nil
                           password:nil];
}

- (void)queryRoomsInfo:(NSString *)roomJid{
    XMPPIQ* iq=[XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:[HQXMPPUserInfo shareXMPPUserInfo].jid];
    [iq addAttributeWithName:@"id" stringValue:@"disco-1"];
    [iq addAttributeWithName:@"to" stringValue:roomJid];
    NSXMLElement* element_query=[NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    [iq addChild:element_query];
    [[HQXMPPManager shareXMPPManager].xmppStream sendElement:iq];
}

- (void)inviteUser:(NSString *)jidStr toRoom:(XMPPRoom *)room withMessage:(NSString *)message{
    XMPPJID * jid = [XMPPJID jidWithString:jidStr];
    [room inviteUser:jid withMessage:message];
}

- (void)joinInChatRoom:(NSString *)roomJid withPassword:(NSString *)password{
    NSString* memberJid=[NSString stringWithFormat:@"%@/%@",roomJid,[HQXMPPUserInfo shareXMPPUserInfo].user];
    XMPPPresence* presence=[XMPPPresence presence];
    [presence addAttributeWithName:@"from" stringValue:[HQXMPPUserInfo shareXMPPUserInfo].jid];
    [presence addAttributeWithName:@"to" stringValue:memberJid];
    NSXMLElement* element_x=[NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    [presence addChild:element_x];
    if (password){
        NSXMLElement* elemnt_password=[NSXMLElement elementWithName:@"password"];
        [elemnt_password setStringValue:password];
        [element_x addChild:elemnt_password];
    }
    [[HQXMPPManager shareXMPPManager].xmppStream sendElement:presence];
    
}

- (void)sendMessage:(NSString *)message inChatRoom:(NSString *)chatRoomJid{
    //    NSString* talkId=chatRoomJid;
    //    NSMutableArray* talks=_messageBundle[talkId];
    //    if (!talks){
    //        talks=[NSMutableArray array];
    //        _messageBundle[talkId]=talks;
    //    }
    
    ///发送xml
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:chatRoomJid];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[HQXMPPUserInfo shareXMPPUserInfo].jid];
    //组合
    [mes addChild:body];
    //发送消息
    [[HQXMPPManager shareXMPPManager].xmppStream sendElement:mes];
}

#pragma mark muc delegate
- (void)xmppMUC:(XMPPMUC *)sender didDiscoverRooms:(NSArray *)rooms forServiceNamed:(NSString *)serviceName{
    DLog(@"didDiscoverRooms");
    [self.roomList removeAllObjects];
    for (XMPPElement * element in rooms) {
        [self.roomList addObject:element.attributesAsDictionary[@"jid"]];
    }
    if (self.updateData) {
        self.updateData(nil);
    }
}

- (void)xmppMUC:(XMPPMUC *)sender failedToDiscoverRoomsForServiceNamed:(NSString *)serviceName withError:(NSError *)error{
    DLog(@"failedToDiscoverRoomsForServiceNamed");
}

- (void)xmppMUC:(XMPPMUC *)sender didDiscoverServices:(NSArray *)services{
    DLog(@"didDiscoverServices");
}

- (void)xmppMUCFailedToDiscoverServices:(XMPPMUC *)sender withError:(NSError *)error{
    DLog(@"xmppMUCFailedToDiscoverServices");
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{
    DLog(@"didReceiveInvitation");
    NSXMLElement * xElement = [message elementForName:@"x"];
     [self joinInChatRoom:[[xElement attributeForName:@"jid"] stringValue] withPassword:nil];
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message{
    DLog(@"didReceiveInvitationDecline");
}

#pragma mark xmppRoom delegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DLog(@"xmppRoomDidCreate");
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DLog(@"xmppRoomDidJoin");
    [sender fetchBanList];
    [sender fetchMembersList];
    [sender fetchModeratorsList];
    [sender configureRoomUsingOptions:[self configNewRoom:sender]];
    [sender fetchConfigurationForm];
    
    if (self.inviteFriendsBlock) {
        self.inviteFriendsBlock(sender);
    }
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    //    DLog(@"configForm:%@",configForm);
    DLog(@"didFetchConfigurationForm");
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    DLog(@"didFetchBanList");
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchBanList");
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    DLog(@"didFetchMembersList");
    for (NSString * str in items) {
        DLog(@"items:%@",str);
    }
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchMembersList");
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    DLog(@"didFetchModeratorsList");
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchModeratorsList");
}

- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
    DLog(@"handleDidLeaveRoom");
}

#pragma mark XMPPRoomStorage Protocol


- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    NSLog(@"handlePresence");
}

- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    NSLog(@"handleIncomingMessage");
}

- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    NSLog(@"handleOutgoingMessage");
}

- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
    return YES;
}

- (void)dealloc{
    [muc deactivate];
    [muc removeDelegate:self];
    muc = nil;
}


@end