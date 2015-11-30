//
//  HQXMPPUserInfo.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

@interface HQXMPPUserInfo : NSObject
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *registerUser;
@property (nonatomic, strong) NSString *registerPwd;
@property (nonatomic, strong) NSString *jid;
@property (nonatomic, strong) NSString * joinRoomName;
@property (nonatomic, assign) BOOL  loginStatus;

+(HQXMPPUserInfo*)shareXMPPUserInfo;

@end
