//
//  HQSingleChatViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQParentViewController.h"
#import "ChatViewForOtherCell.h"
#import "ChatViewCell.h"
#import "HQXMPPManager.h"

@interface HQSingleChatViewController : HQParentViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatMessageTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (strong, nonatomic) XMPPUserCoreDataStorageObject * userInfromation;


@end
