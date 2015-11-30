//
//  HQUserViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQUserViewController.h"

@interface HQUserViewController ()

@end

@implementation HQUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"UserInfo";
}

- (IBAction)logoutButtonAction:(id)sender {
    __weak HQUserViewController * weakSelf = self;
    [[HQXMPPManager shareXMPPManager] xmppUserlogoutWithResult:^(XMPPResultType type) {
        [HQXMPPUserInfo shareXMPPUserInfo].user = @"";
        [HQXMPPUserInfo shareXMPPUserInfo].registerUser = @"";
         [weakSelf handleResultType:type];
    }];
}

-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{// 主线程刷新UI
        if (type == XMPPResultTypeLogoutSuccess) {
            self.tabBarController.selectedIndex = 0;
        }
            });
    
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
