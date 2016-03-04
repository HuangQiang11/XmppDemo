//
//  HQFriendListViewController.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/27.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQFriendListViewController.h"
#import "XMPPvCardTemp.h"
@interface HQFriendListViewController (){
    XMPPUserCoreDataStorageObject * userInfromation;
}

@end

@implementation HQFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLoginView:) name:MoveView object:nil];
    self.navigationItem.title = @"Friend List";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![HQXMPPUserInfo shareXMPPUserInfo].loginStatus) {
        UINib * nib = [UINib nibWithNibName:@"HQLoginView" bundle:nil];
        HQLoginView * loginView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        loginView.frame = [UIScreen mainScreen].bounds;
        [self.tabBarController.view addSubview:loginView];
        loginView.tag = LoginViewTag;
    }
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
    //remove friend and friend will receive message in didReceivePresence(XMPPStreamDelegate) method
    /*
     <presence xmlns="jabber:client" type="unsubscribed" from="g0000000008@gzserver-pc" to="user1@gzserver-pc"><delay xmlns="urn:xmpp:delay" stamp="2015-11-30T05:58:23.742Z" from="gzserver-pc">Offline Storage - gzserver-pc</delay></presence>
     */
    
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
    cell.textLabel.text = user.jidStr;
    
     XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:user.jid shouldFetch:YES];
     cell.detailTextLabel.text = friendvCard.nickname;
     cell.imageView.image = [[UIImage alloc]initWithData:friendvCard.photo];
    /*
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
     */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    userInfromation = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"HQSingleChatViewController" sender:self];
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

- (void)removeLoginView:(NSNotification*) notification{
    UIView * loginView = [self.tabBarController.view viewWithTag:LoginViewTag];
    [UIView animateWithDuration:0.5 animations:^{
        loginView.frame = CGRectMake( loginView.frame.origin.x,[UIScreen mainScreen].bounds.size.height, loginView.frame.size.width, loginView.frame.size.height);
    } completion:^(BOOL finished) {
        [loginView removeFromSuperview];
    }];
    [self initData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"HQSingleChatViewController"]) {
        HQSingleChatViewController * singleChatVC = segue.destinationViewController;
        singleChatVC.userInfromation = userInfromation;
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
