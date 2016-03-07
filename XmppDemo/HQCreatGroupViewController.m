//
//  HQCreatGroupViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQCreatGroupViewController.h"

@interface HQCreatGroupViewController (){
    NSMutableArray * selectArr;
}

@end

@implementation HQCreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.blackBackgroudView addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated{
    self.descriptionTextView.layer.cornerRadius = 10;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.borderColor = [UIColor redColor].CGColor;
    self.descriptionTextView.layer.borderWidth = 1;
    self.descriptionTextView.textColor = [UIColor grayColor];
    self.descriptionTextView.text = @"Group Description";
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    [self initData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storageTool.fetchedResultsController.fetchedObjects.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"friendCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryView = nil;
    UIImageView * selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
    cell.accessoryView = selectImage;
    XMPPUserCoreDataStorageObject * user = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = user.jidStr;
    if ([selectArr containsObject:user]) {
        selectImage.image = [UIImage imageNamed:@"tick"];
    }else{
        selectImage.image = [UIImage imageNamed:@"add"];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject * user = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
    if ([selectArr containsObject:user]) {
        [selectArr removeObject:user];
    }else{
        [selectArr addObject:user];
    }
    [self.friendListTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.textColor ==[UIColor lightGrayColor]) {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Group Description";
        textView.textColor=[UIColor lightGrayColor];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark private method
- (void)keyBoardShow:(NSNotification *)notification{
    //get keyBoard height
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //set contraint
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomViewBottomConstraint.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardHidden:(NSNotification *)notification{

}

- (void)initData{
    selectArr = [NSMutableArray array];
    if ([HQXMPPUserInfo shareXMPPUserInfo].loginStatus) {
        self.storageTool = [[HQRosterStorageTool alloc] init];
        __weak HQCreatGroupViewController * weakSelf = self;
        self.storageTool.dataUpdate = ^ (id sender){
            [weakSelf.friendListTableView reloadData];
        };
        [self.friendListTableView reloadData];
    }
}


#pragma mark all click
- (IBAction)doneButtonAction:(id)sender {
    self.blackBackgroudView.hidden = NO;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sureButtonAction:(id)sender {
    NSString * roomJid=[NSString stringWithFormat:@"%@@muc.%@",self.groupNameTextField.text,kDOMAIN];
    __weak HQXMPPChatRoomManager * weakManager = [HQXMPPChatRoomManager shareChatRoomManager];
    [HQXMPPChatRoomManager shareChatRoomManager].inviteFriendsBlock = ^(XMPPRoom * room){
        for (XMPPUserCoreDataStorageObject * user in selectArr) {
            [weakManager inviteUser:user.jidStr toRoom:room withMessage:self.descriptionTextView.text];
        }
    };
    [[HQXMPPChatRoomManager shareChatRoomManager] creatChatRoom:roomJid];
    [self tapAction];
}

- (IBAction)cancelButtonAcion:(id)sender {
    [self tapAction];
}

- (void)tapAction{
    self.blackBackgroudView.hidden = YES;
     [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomViewBottomConstraint.constant = -150;
        [self.view layoutIfNeeded];
    }];
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
