//
//  HQGroupChatViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQGroupChatViewController.h"
#import "MessageStorageTool.h"
#import "HQXMPPChatRoomManager.h"
#import "NSString+HQUtility.h"
#import "ChatModel.h"
#import "NSMutableArray+HQUtility.h"
#import "ChatViewCell.h"
#import "ChatViewForOtherCell.h"
@interface HQGroupChatViewController ()
@property (strong, nonatomic) MessageStorageTool * messageTool;
@end

@implementation HQGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard:)];
    self.chatMessageTableView.userInteractionEnabled = YES;
    [self.chatMessageTableView addGestureRecognizer:tap];
    [self.chatMessageTableView registerNib:[UINib nibWithNibName:@"ChatViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.chatMessageTableView registerNib:[UINib nibWithNibName:@"ChatViewForOtherCell" bundle:nil] forCellReuseIdentifier:@"cell2"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.roomName;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HQXMPPChatRoomManager shareChatRoomManager] joinInChatRoom:[NSString jidStrWithRoomName:self.roomName] withPassword:nil];
    [HQXMPPUserInfo shareXMPPUserInfo].joinRoomName = [NSString jidStrWithRoomName:self.roomName];
}

- (MessageStorageTool *)messageTool{
    if (!_messageTool) {
        _messageTool = [[MessageStorageTool alloc] init];
        __weak typeof(self) weakSelf = self;
        _messageTool.updateData = ^{
            [weakSelf.chatMessageTableView reloadData];
            [weakSelf setTableViewContentSize];
        };
        _messageTool.roomJidStr = self.roomName;
    }
    return _messageTool;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.messageTool.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *msg =  self.messageTool.messageArr[indexPath.row];
    NSString * userName = [NSString userNameWithGroupChatFromName:msg.message.fromStr];
    if ([userName hasPrefix:[HQXMPPUserInfo shareXMPPUserInfo].user]) {
        ChatViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setdata:msg];
        cell.namelable.text = @"me";
        return cell;
    }else{
        ChatViewForOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        [cell setdata:msg];
        cell.name.text = userName;
        return cell;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *msg =  self.messageTool.messageArr[indexPath.row];
    CGRect rect=[msg.body boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
    return 42+rect.size.height+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqual:@""] || textView.text == nil) {
        self.sendMessageButton.enabled = NO;
    }else{
        self.sendMessageButton.enabled = YES;
    }
}

#pragma mark all click
- (IBAction)sendMessageButton:(id)sender {
    [[HQXMPPChatRoomManager shareChatRoomManager] sendMessage:self.inputTextView.text inChatRoom:[NSString jidStrWithRoomName:self.roomName]];
    self.inputTextView.text=@"";
    self.sendMessageButton.enabled = NO;
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark private method
- (void)keyBoardShow:(NSNotification *)notification{
    //get keyBoard height
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //set contraint
    self.bottomViewBottomConstraint.constant = height;
    [self.view layoutIfNeeded];
    [self setTableViewContentSize];
}

- (void)keyBoardHidden:(NSNotification *)notification{
    self.bottomViewBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [self setTableViewContentSize];
}

- (void)setTableViewContentSize{
    if (self.messageTool.messageArr.count < 1) {
        return;
    }
    [self.chatMessageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageTool.messageArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMessage:(NSNotification *)notification{

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
