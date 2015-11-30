//
//  HQGroupChatViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQGroupChatViewController.h"

@interface HQGroupChatViewController ()

@end

@implementation HQGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:ReceiveGroupChatMessage object:nil];
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
    self.dataArray =[NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HQXMPPChatRoomManager shareChatRoomManager] joinInChatRoom:[NSString jidStrWithRoomName:self.roomName] withPassword:nil];
    [HQXMPPUserInfo shareXMPPUserInfo].joinRoomName = [NSString jidStrWithRoomName:self.roomName];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel * model=self.dataArray[indexPath.row];
    if ([model.name isEqualToString:[HQXMPPUserInfo shareXMPPUserInfo].user]) {
        ChatViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setDataForGroup:model];
        cell.namelable.text = @"me";
        return cell;
    }else{
        ChatViewForOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        [cell setDataForGroupChat:model];
        cell.messageButton.enabled=YES;
        cell.messageButton.tag=indexPath.row;
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel * model=self.dataArray[indexPath.row];
    CGRect rect=[model.message boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
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
    if (self.dataArray.count < 1) {
        return;
    }
    [self.chatMessageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMessage:(NSNotification *)notification{
    [self performSelectorOnMainThread:@selector(updateUi:) withObject:notification.object waitUntilDone:NO];
}

- (void)updateUi:(XMPPMessage *)message{
    ChatModel * model = [ChatModel creatChatModelWith:message];
    if (model.isHistory) {
        [self.dataArray sortAndAddObject:model];
    }else{
        [self.dataArray addObject:model];
    }
    [self.chatMessageTableView reloadData];
    [self setTableViewContentSize];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
