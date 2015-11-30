//
//  HQGroupListViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQGroupListViewController.h"

@interface HQGroupListViewController (){
    NSString * selectRoomName;
}

@end

@implementation HQGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Group List";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    __weak HQGroupListViewController * weakSelf = self;
    [HQXMPPChatRoomManager shareChatRoomManager].updateData = ^(id sender){
        [weakSelf.groupListTableView reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [[HQXMPPChatRoomManager shareChatRoomManager] queryRooms];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [HQXMPPChatRoomManager shareChatRoomManager].roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [HQXMPPChatRoomManager shareChatRoomManager].roomList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRoomName = [HQXMPPChatRoomManager shareChatRoomManager].roomList[indexPath.row];
    [self performSegueWithIdentifier:@"HQGroupChatViewController" sender:self];
}

#pragma mark button click
- (void)rightButtonItem:(UIBarButtonItem *)rightButtonItem{
    [self performSegueWithIdentifier:@"HQCreatGroupViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"HQGroupChatViewController"]) {
        HQGroupChatViewController * groupChatVC = segue.destinationViewController;
        groupChatVC.roomName = [NSString useNameWithUserJid:selectRoomName];
    }
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
