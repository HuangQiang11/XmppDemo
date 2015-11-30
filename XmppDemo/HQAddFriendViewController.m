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
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        self.sureButton.enabled = NO;
    }else{
        self.sureButton.enabled = YES;
    }
    return YES;
}

#pragma mark button click
- (IBAction)sureButtonAction:(id)sender {
    if (self.inputTextField.text != nil && ![self.inputTextField.text isEqual:@""]) {
        //add friend and friend will receive message in didReceivePresenceSubscriptionRequest(XMPPRosterDelegate) method
        [self addFriendWithFriendName:self.inputTextField.text];
    }
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
