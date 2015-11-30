//
//  ChatViewCell.h
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+HQUtility.h"
#import "config.h"
#import "ChatModel.h"
@interface ChatViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
- (void)setdata:(id)model;
- (void)setDataForGroup:(ChatModel *)model;
@end
