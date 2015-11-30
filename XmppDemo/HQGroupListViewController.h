//
//  HQGroupListViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQXMPPChatRoomManager.h"
#import "HQGroupChatViewController.h"

@interface HQGroupListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *groupListTableView;

@end
