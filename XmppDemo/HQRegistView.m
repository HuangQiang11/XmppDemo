//
//  HQRegistView.m
//  XMPPDemo
//
//  Created by ttlgz-0022 on 15/11/22.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQRegistView.h"

@implementation HQRegistView

- (IBAction)registButtonAction:(id)sender {
    if (self.userNameTextField.text != nil && self.passwordTextField.text != nil && ![self.userNameTextField.text isEqual:@""] && ![self.passwordTextField.text isEqual:@""]) {
        [HQXMPPUserInfo shareXMPPUserInfo].registerUser = self.userNameTextField.text;
        [HQXMPPUserInfo shareXMPPUserInfo].registerPwd = self.passwordTextField.text;
        __weak HQRegistView * weakSelf = self;
        [[HQXMPPManager shareXMPPManager] xmppUserRegisterWithResutl:^(XMPPResultType type) {
            [weakSelf handleResultType:type];
        }];
    }

}

-(void)handleResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeNetErr:
                DLog(@"网络不稳定");
                break;
            case XMPPResultTypeRegisterSuccess:
                [SVProgressHUD showSuccessWithStatus:@"注册成功，请重新登录"];
                [self removeFromSuperview];
                break;
                
            case XMPPResultTypeRegisterFailure:
                DLog(@"注册失败,用户名重复");
                break;
            default:
                break;
        }
    });
    
    
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
