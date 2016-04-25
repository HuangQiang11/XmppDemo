//
//  MessageTool.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/4/22.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^updateBlock)();
@interface MessageStorageTool : NSObject
@property (strong, nonatomic) NSMutableArray * messageArr;
@property (copy, nonatomic) updateBlock updateData;
@property (copy, nonatomic) NSString *  userJid;
@property (copy, nonatomic) NSString * roomJidStr;
@end
