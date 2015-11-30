//
//  HQLoginView.m
//  XMPPDemo
//
//  Created by ttlgz-0022 on 15/11/22.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQLoginView.h"

@implementation HQLoginView

- (IBAction)testButtonAction:(id)sender {
    if (self.userNameTextField.text != nil && self.passwordTextField.text != nil && ![self.userNameTextField.text isEqual:@""] && ![self.passwordTextField.text isEqual:@""]) {
        [HQXMPPUserInfo shareXMPPUserInfo].user = self.userNameTextField.text;
        [HQXMPPUserInfo shareXMPPUserInfo].pwd = self.passwordTextField.text;
        __weak HQLoginView * weakSelf = self;
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
                DLog(@"登录成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:MoveView object:nil];
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                DLog(@"The Name or password wrong");
                break;
            case XMPPResultTypeNetErr:
                DLog(@"Network is not available");
            default:
                break;
        }
    });
    
}


- (IBAction)registButtonAction:(id)sender {
    UINib * nib = [UINib nibWithNibName:@"HQRegistView" bundle:nil];
    HQRegistView * registView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    registView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:registView];
    [UIView animateWithDuration:0.5 animations:^{
        registView.frame = self.bounds;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
