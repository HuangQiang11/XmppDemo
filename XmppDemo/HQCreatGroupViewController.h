//
//  HQCreatGroupViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRosterStorageTool.h"
#import "HQXMPPChatRoomManager.h"

@interface HQCreatGroupViewController : UIViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *friendListTableView;
@property (weak, nonatomic) IBOutlet UIView *blackBackgroudView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) HQRosterStorageTool * storageTool;
@end
