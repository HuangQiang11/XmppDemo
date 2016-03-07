//
//  HQAddFriendViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQAddFriendViewController.h"

@interface HQAddFriendViewController ()

@end

@implementation HQAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add Friends";
    [self.inputTextField addTarget:self action:@selector(inputViewValueChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark button click
- (IBAction)sureButtonAction:(id)sender {
    NSLog(@"sure");
    if (self.inputTextField.text != nil && ![self.inputTextField.text isEqual:@""]) {
        //add friend and friend will receive message in didReceivePresenceSubscriptionRequest(XMPPRosterDelegate) method
        [self addFriendWithFriendName:self.inputTextField.text];
    }
}

- (void)inputViewValueChange:(UITextField *)textField{
    if ([textField.text isEqual:@""]) {
        self.sureButton.enabled = NO;
    }else{
        self.sureButton.enabled = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark private method
- (void)addFriendWithFriendName:(NSString *)userName{
    if([userName isEqualToString:[HQXMPPUserInfo shareXMPPUserInfo].user]){
        
        [self showAlert:@"不能添加自己为好友"];
        return;
    }
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",userName,kDOMAIN];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    if([[HQXMPPManager shareXMPPManager].rosterStorage userExistsWithJID:friendJid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream]){
        [self showAlert:@"当前好友已经存在"];
        return;
    }
    XMPPJID * jid = [XMPPJID jidWithString:jidStr];
    [[HQXMPPManager shareXMPPManager].roster subscribePresenceToUser:jid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

@end
