//
//  HQFriendListViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQFriendListViewController.h"
#import "XMPPvCardTemp.h"
#import "HQRosterStorageTool.h"
@interface HQFriendListViewController ()

@end

@implementation HQFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Friend List";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark private
- (void)initData{
    if ([HQXMPPUserInfo shareXMPPUserInfo].loginStatus) {
        self.storageTool = [[HQRosterStorageTool alloc] init];
        __weak HQFriendListViewController * weakSelf = self;
        self.storageTool.dataUpdate = ^ (id sender){
            [weakSelf.friendTableView reloadData];
        };
        [self.friendTableView reloadData];
    }
}

- (void)deleteFriendWithFriendName:(XMPPJID *)jid{
    [[HQXMPPManager shareXMPPManager].roster removeUser:jid];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storageTool.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"friendCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    XMPPUserCoreDataStorageObject * user = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
    
     XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:user.jid shouldFetch:YES];
    if (friendvCard.nickname) {
        cell.textLabel.text = friendvCard.nickname;
    }else{
         cell.textLabel.text = user.jidStr;
    }
     cell.imageView.image = [[UIImage alloc]initWithData:friendvCard.photo];

    cell.accessoryView = nil;
    UILabel * statueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    cell.accessoryView = statueLabel;
    switch ([(NSNumber *)[user valueForKey:@"sectionNum"] intValue]) {
        case 0:
            statueLabel.textColor = [UIColor redColor];
            statueLabel.text = @"OnLine";
            break;
        case 1:
        case 2:
            statueLabel.textColor = [UIColor grayColor];
            statueLabel.text = @"OffLine";
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject * user = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"HQSingleChatViewController" sender:user];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *friend = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = friend.jid;
        [self deleteFriendWithFriendName:friendJid];
    }
}

#pragma mark button click  
- (void)rightButtonItem:(UIBarButtonItem *)rightButtonItem{
    [self performSegueWithIdentifier:@"HQAddFriendViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"HQSingleChatViewController"]) {
        id singleChatVC = segue.destinationViewController;
        [singleChatVC setValue:sender forKey:@"userInfromation"];
    }
}

@end
