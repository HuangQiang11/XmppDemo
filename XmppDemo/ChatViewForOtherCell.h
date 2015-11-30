//
//  ChatViewForOtherCell.h
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewCell.h"
#import "ChatViewForOtherCell.h"
#import "ChatModel.h"
@interface ChatViewForOtherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

-(void)setdata:(id)model;
- (void)setDataForGroupChat:(ChatModel *)model;
@end
