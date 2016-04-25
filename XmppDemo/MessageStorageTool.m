//
//  MessageTool.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/4/22.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "MessageStorageTool.h"
#import "HQXMPPManager.h"
#import "NSString+HQUtility.h"

@interface MessageStorageTool()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController * _resultsContr;
}
@end
@implementation MessageStorageTool

- (void)setUserJid:(NSString *)userJid{
    _userJid = userJid;
    [self loadMsgsWith:userJid];
}

- (void)setRoomJidStr:(NSString *)roomJidStr{
    _roomJidStr = roomJidStr;
    [self loadRoomMsgsWith:roomJidStr];
}

- (void)loadRoomMsgsWith:(NSString *)roomJidStr{
    NSManagedObjectContext *context = [HQXMPPManager shareXMPPManager].msgStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"outgoing = 0 AND bareJidStr = %@",[NSString jidStrWithRoomName:roomJidStr]];
    request.predicate = pre;
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    _resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *err = nil;
    [_resultsContr performFetch:&err];
    _resultsContr.delegate = self;
    if (err) {
        NSLog(@"%@",err);
    }
    self.messageArr = [NSMutableArray arrayWithArray:_resultsContr.fetchedObjects];

}

-(void)loadMsgsWith:(NSString *)userJid{
    NSManagedObjectContext *context = [HQXMPPManager shareXMPPManager].msgStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    XMPPJID * friendNameJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[NSString useNameWithUserJid:userJid],kDOMAIN]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[HQXMPPUserInfo  shareXMPPUserInfo].jid,friendNameJid.bare];
    request.predicate = pre;
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    _resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *err = nil;
    [_resultsContr performFetch:&err];
    _resultsContr.delegate = self;
    if (err) {
        NSLog(@"%@",err);
    }
    self.messageArr = [NSMutableArray arrayWithArray:_resultsContr.fetchedObjects];
}

- (void)dealloc{
    _resultsContr.delegate = nil;
    _resultsContr = nil;
}

#pragma mark NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    self.messageArr = [NSMutableArray arrayWithArray:_resultsContr.fetchedObjects];
    if (self.updateData) {
        self.updateData();
    }
}
@end
