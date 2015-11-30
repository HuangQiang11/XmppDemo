//
//  ChatModel.m
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
+ (ChatModel *)creatChatModelWith:(XMPPMessage *)message{
    ChatModel * model = [[ChatModel alloc] init];
    model.name = [NSString userNameWithGroupChatFromName:message.fromStr];
    model.chatRoomName = [NSString roomNameWithGroupChatFromName:message.fromStr];
    model.message = message.body;
    NSXMLElement * delayElement = [message elementForName:@"delay"];
    model.time = [[delayElement attributeForName:@"stamp"] stringValue];
    NSXMLElement * xElement = [message elementForName:@"x"];
    if (xElement) {
        model.isHistory = YES;
    }else{
        model.isHistory = NO;
    }
    return model;
}
@end
