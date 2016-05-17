//
//  HQCreatGroupViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQParentViewController.h"

@class PlaceholdTextView;
@class HQRosterStorageTool;
@interface HQCreatGroupViewController : HQParentViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *friendListTableView;
@property (weak, nonatomic) IBOutlet UIView *blackBackgroudView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet PlaceholdTextView *descriptionTextView;
@property (strong, nonatomic) HQRosterStorageTool * storageTool;
@end
