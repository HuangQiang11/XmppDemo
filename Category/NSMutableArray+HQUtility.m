//
//  NSMutableArray+HQUtility.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/30.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "NSMutableArray+HQUtility.h"

@implementation NSMutableArray (HQUtility)
- (void)sortAndAddObject:(id) model{
    if (self.count == 0) {
        [self addObject:model];
    }else{
        NSString * str2 = [model valueForKey:@"time"];
        NSUInteger  cou = self.count;
        for (int i = 0; i < cou; i++) {
            id object = self[i];
            NSString * str1 = [object valueForKey:@"time"];
            NSComparisonResult result = [str1 compare:str2];
            if (result != NSOrderedAscending ) {
                [self insertObject:model atIndex:i];
                break;
            }else if (i == cou - 1) {
                [self addObject:model];
            }
        }
        
    }
}
@end
