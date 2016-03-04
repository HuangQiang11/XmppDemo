//
//  HQModifyViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/4.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "HQModifyViewController.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
@interface HQModifyViewController ()
{

    __weak IBOutlet UITextField *nameTextField;
}
@end

@implementation HQModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)saveButtonAction:(id)sender {
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp * myVCard =[HQXMPPManager shareXMPPManager].vCard.myvCardTemp;
    myVCard.nickname = nameTextField.text;
    [[HQXMPPManager shareXMPPManager].vCard updateMyvCardTemp:myVCard];
}


@end
