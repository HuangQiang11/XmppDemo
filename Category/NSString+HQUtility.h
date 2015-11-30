//
//  NSString+HQUtility.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

@interface NSString (HQUtility)
+ (NSString *)useNameWithUserJid:(NSString *)jidStr;
+ (NSString *)stringYMDHMSFromDate:(NSDate *)date;
+ (NSString *)jidStrWithUserName:(NSString *)userName;
+ (NSString *)jidStrWithRoomName:(NSString *)roomName;
+ (NSString *)userNameWithGroupChatFromName:(NSString *)fromName;
+ (NSString *)roomNameWithGroupChatFromName:(NSString *)fromName;
@end
