//
//  HQFriendListViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQParentViewController.h"
#import "HQRosterStorageTool.h"

@interface HQFriendListViewController : HQParentViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) HQRosterStorageTool * storageTool;

@end
