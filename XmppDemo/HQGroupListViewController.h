//
//  HQGroupListViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQParentViewController.h"
#import "HQXMPPChatRoomManager.h"
#import "HQGroupChatViewController.h"

@interface HQGroupListViewController : HQParentViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *groupListTableView;

@end
