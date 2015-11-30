//
//  NSString+HQUtility.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "NSString+HQUtility.h"

@implementation NSString (HQUtility)
+ (NSString *)useNameWithUserJid:(NSString *)jidStr{
    NSRange range = [jidStr rangeOfString:@"@"];
    NSString * userName = [jidStr substringToIndex:range.location];
    return userName;
}

+(NSString *)stringYMDHMSFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

+ (NSString *)jidStrWithUserName:(NSString *)userName{
    return [NSString stringWithFormat:@"%@@%@",userName,kDOMAIN];
}

+ (NSString *)jidStrWithRoomName:(NSString *)roomName{
    return [NSString stringWithFormat:@"%@@muc.%@",roomName,kDOMAIN];
}

+ (NSString *)userNameWithGroupChatFromName:(NSString *)fromName{
    NSRange range = [fromName rangeOfString:@"/"];
    return [fromName substringFromIndex:range.location+1];
}

+ (NSString *)roomNameWithGroupChatFromName:(NSString *)fromName{
    NSRange range = [fromName rangeOfString:@"/"];
    return [fromName substringToIndex:range.location];
}
@end
