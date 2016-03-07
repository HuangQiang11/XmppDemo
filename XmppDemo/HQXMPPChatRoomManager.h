//
//  HQChatRoomManager.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQXMPPManager.h"

typedef void (^block)(id);
typedef void (^updateDataBlock)(id);
@interface HQXMPPChatRoomManager : NSObject<XMPPMUCDelegate,XMPPRoomDelegate,XMPPRoomStorage>
{
    XMPPMUC * muc;
}
@property (nonatomic, copy) block inviteFriendsBlock;
@property (nonatomic, copy) updateDataBlock updateData;
@property (nonatomic, strong) NSMutableArray * roomList;

+ (HQXMPPChatRoomManager *)shareChatRoomManager;
- (void)creatChatRoom:(NSString *)roomJid;
- (void)queryRooms;
- (void)inviteUser:(NSString *)jidStr toRoom:(XMPPRoom *)room withMessage:(NSString *)message;
- (void)joinInChatRoom:(NSString *)roomJid withPassword:(NSString *)password;
- (void)sendMessage:(NSString *)message inChatRoom:(NSString *)chatRoomJid;
@end
