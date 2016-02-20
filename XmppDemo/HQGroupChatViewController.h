//
//  HQGroupChatViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQXMPPChatRoomManager.h"
#import "NSString+HQUtility.h"
#import "ChatModel.h"
#import "NSMutableArray+HQUtility.h"
#import "ChatViewCell.h"
#import "ChatViewForOtherCell.h"

@interface HQGroupChatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultsContr;
}
@property (weak, nonatomic) IBOutlet UITableView *chatMessageTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (strong, nonatomic) NSString * roomName;
@property (strong, nonatomic) NSMutableArray * dataArray;
@end
