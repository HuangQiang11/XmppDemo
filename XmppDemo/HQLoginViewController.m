//
//  HQLoginViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/7.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "HQLoginViewController.h"
#import "HQRegisterViewController.h"
#import "HQXMPPManager.h"
#import "SVProgressHUD.h"
#import "HQXMPPChatRoomManager.h"
@interface HQLoginViewController ()

@end

@implementation HQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)loginButtonAction:(id)sender {
    if (self.userNameTextField.text != nil && self.passwordTextField.text != nil && ![self.userNameTextField.text isEqual:@""] && ![self.passwordTextField.text isEqual:@""]) {
        [HQXMPPUserInfo shareXMPPUserInfo].user = self.userNameTextField.text;
        [HQXMPPUserInfo shareXMPPUserInfo].pwd = self.passwordTextField.text;
        __weak HQLoginViewController * weakSelf = self;
        [SVProgressHUD show];
        [[HQXMPPManager shareXMPPManager] xmppUserLoginWithResult:^(XMPPResultType type) {
            [weakSelf handleResultType:type];
        }];
    }

}

-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{                                // 主线程刷新UI
        [SVProgressHUD dismiss];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [[HQXMPPChatRoomManager shareChatRoomManager] setup];
                [self switchUi];
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                NSLog(@"The Name or password wrong");
                break;
            case XMPPResultTypeNetErr:
                NSLog(@"Network is not available");
            default:
                break;
        }
    });
    
}

- (IBAction)registerButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"HQRegisterViewController" sender:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)switchUi{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
}
@end
