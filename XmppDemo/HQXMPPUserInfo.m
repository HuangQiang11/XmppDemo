//
//  HQXMPPUserInfo.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQXMPPUserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"

@implementation HQXMPPUserInfo
static HQXMPPUserInfo * XMPPUser;

+(HQXMPPUserInfo*)shareXMPPUserInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XMPPUser=[[HQXMPPUserInfo alloc] init];
    });
    return XMPPUser;
}

-(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.user,kDOMAIN];
}
@end
