//
//  ChatModel.h
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "NSString+HQUtility.h"
@interface ChatModel : NSObject
@property (strong ,nonatomic) NSString * time;
@property (strong ,nonatomic) NSString * name;
@property (strong ,nonatomic) NSString * message;
@property (strong ,nonatomic) NSString * icon;
@property (strong ,nonatomic) NSString * chatRoomName;
@property (assign ,nonatomic) BOOL isHistory;
+ (ChatModel *)creatChatModelWith:(XMPPMessage *)message;
@end
