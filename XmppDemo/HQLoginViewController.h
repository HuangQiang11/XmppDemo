//
//  HQLoginViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/7.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRegisterViewController.h"
#import "HQXMPPManager.h"
#import "SVProgressHUD.h"

@interface HQLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
