//
//  HQRosterStorageTool.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQXMPPManager.h"

typedef void (^dataUpdateBlock)(id);
@interface HQRosterStorageTool : NSObject<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, copy) dataUpdateBlock dataUpdate;
@end
