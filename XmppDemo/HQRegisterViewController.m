//
//  HQRegisterViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/7.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "HQRegisterViewController.h"
#import "HQXMPPUserInfo.h"
#import "HQXMPPManager.h"
#import "SVProgressHUD.h"

@interface HQRegisterViewController ()

@end

@implementation HQRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)registButtonAction:(id)sender {
    if (self.userNameTextField.text != nil && self.passwordTextField.text != nil && ![self.userNameTextField.text isEqual:@""] && ![self.passwordTextField.text isEqual:@""]) {
        [HQXMPPUserInfo shareXMPPUserInfo].registerUser = self.userNameTextField.text;
        [HQXMPPUserInfo shareXMPPUserInfo].registerPwd = self.passwordTextField.text;
        __weak HQRegisterViewController * weakSelf = self;
        [[HQXMPPManager shareXMPPManager] xmppUserRegisterWithResutl:^(XMPPResultType type) {
            [weakSelf handleResultType:type];
        }];
    }
    
}

-(void)handleResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeNetErr:
                NSLog(@"网络不稳定");
                break;
            case XMPPResultTypeRegisterSuccess:
                [SVProgressHUD showSuccessWithStatus:@"注册成功，请重新登录"];
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            case XMPPResultTypeRegisterFailure:
                NSLog(@"注册失败,用户名重复");
                break;
            default:
                break;
        }
    });
    
    
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
