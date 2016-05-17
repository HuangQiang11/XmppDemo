//
//  HQUserViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQUserViewController.h"
#import "XMPPvCardTemp.h"
#import "HQXMPPChatRoomManager.h"
@interface HQUserViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{

    __weak IBOutlet UIButton *nickNameButton;
    __weak IBOutlet UIButton *iconButton;
}

@end

@implementation HQUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"UserInfo";
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp * myVCard =[HQXMPPManager shareXMPPManager].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        [iconButton setBackgroundImage:[UIImage imageWithData:myVCard.photo] forState:UIControlStateNormal];
    }else{
        [iconButton setTitle:@"Add icon" forState:UIControlStateNormal];
    }
    
    // 设置昵称
    if (myVCard.nickname) {
        [nickNameButton setTitle:myVCard.nickname forState:UIControlStateNormal];
    }else{
        [nickNameButton setTitle:@"modify or add" forState:UIControlStateNormal];
    }
}

- (IBAction)iconButtonAction:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 设置代理
    imagePicker.delegate =self;
    
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)nickNameButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"HQModifyViewController" sender:nil];
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
            [[HQXMPPChatRoomManager shareChatRoomManager] deactivateMuc];
            [self switchUi];
        }
            });
}

- (void)switchUi{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
}


#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    // 获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];

    [iconButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 更新到服务器
    XMPPvCardTemp *myvCard = [HQXMPPManager shareXMPPManager].vCard.myvCardTemp;
    myvCard.photo = UIImageJPEGRepresentation(image, 0.02);
    [[HQXMPPManager shareXMPPManager].vCard updateMyvCardTemp:myvCard];
}




@end
