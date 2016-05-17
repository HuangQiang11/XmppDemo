//
//  HQSingleChatViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQSingleChatViewController.h"
#import "MessageStorageTool.h"
#import "ChatViewForOtherCell.h"
#import "ChatViewCell.h"
#import "HQXMPPManager.h"
@interface HQSingleChatViewController ()
@property (strong, nonatomic) MessageStorageTool * messageTool;
@end

@implementation HQSingleChatViewController

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
    self.navigationItem.title = [NSString useNameWithUserJid:self.userInfromation.jidStr];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadMsgs];
    [self setTableViewContentSize];
}

#pragma mark lazy
- (MessageStorageTool *)messageTool{
    if (!_messageTool) {
        _messageTool = [[MessageStorageTool alloc] init];
        __weak typeof(self) weakSelf = self;
        _messageTool.updateData = ^{
            [weakSelf.chatMessageTableView reloadData];
            [weakSelf setTableViewContentSize];
        };
        _messageTool.userJid = self.userInfromation.jidStr;
    }
    return _messageTool;
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageTool.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *msg =  self.messageTool.messageArr[indexPath.row];
    if ([msg.outgoing boolValue]) {
        ChatViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setdata:msg];
        cell.namelable.text = @"me";
        return cell;
    }else{
        ChatViewForOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        [cell setdata:msg];
        cell.name.text = [NSString useNameWithUserJid:self.userInfromation.jidStr];
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

#pragma mark all click
- (IBAction)sendMessageButton:(id)sender {
    XMPPJID * friendNameJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[NSString useNameWithUserJid:self.userInfromation.jidStr],kDOMAIN]];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:friendNameJid];
    [msg addBody:self.inputTextView.text];
    [[HQXMPPManager shareXMPPManager].xmppStream sendElement:msg];
    self.inputTextView.text = @"";
    
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
