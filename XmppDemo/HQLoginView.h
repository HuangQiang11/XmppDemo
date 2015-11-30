//
//  HQLoginView.h
//  XMPPDemo
//
//  Created by ttlgz-0022 on 15/11/22.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRegistView.h"
#import "HQXMPPManager.h"
#import "DLog.h"
#import "SVProgressHUD.h"


#define LoginViewTag 500
@interface HQLoginView : UIView
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end
