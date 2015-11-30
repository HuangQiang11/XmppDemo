//
//  HQAddFriendViewController.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQXMPPManager.h"

@interface HQAddFriendViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end
