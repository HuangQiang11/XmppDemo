//
//  ChatViewForOtherCell.m
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "ChatViewForOtherCell.h"
@implementation ChatViewForOtherCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.layer.cornerRadius=15;
    self.icon.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setdata:(id)model{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.time.text = nil;
    self.name.text = nil;
    self.time.text = [NSString stringYMDHMSFromDate:(NSDate *)[model valueForKey:@"timestamp"]];
    self.name.text = [model valueForKey:@"bareJidStr"];
    CGRect rect = [[model valueForKey:@"body"] boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
    
    CGFloat contentX = 40;
    
    UIImage * image = [UIImage imageNamed:@"cream"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.7];
    [self.messageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.messageButton.frame = CGRectMake(contentX, 30, rect.size.width+30, rect.size.height+30);
    self.messageButton.titleLabel.numberOfLines = 0;
    [self.messageButton setTitle:[model valueForKey:@"body"] forState:UIControlStateNormal];
    self.messageButton.titleEdgeInsets =  UIEdgeInsetsMake(5, 20, 5, 5);
    self.messageButton.enabled = NO;
}

- (void)setDataForGroupChat:(ChatModel *)model{
    self.time.text=nil;
    self.name.text=nil;
    self.time.text= model.time;
    self.name.text=model.name;
    CGRect rect=[model.message boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
    
    CGFloat contentX=40;
    
    UIImage * image=[UIImage imageNamed:@"cream"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.7];
    [self.messageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.messageButton.frame=CGRectMake(contentX, 30, rect.size.width+30, rect.size.height+30);
    self.messageButton.titleLabel.numberOfLines=0;
    [self.messageButton setTitle:model.message forState:UIControlStateNormal];
    self.messageButton.titleEdgeInsets=UIEdgeInsetsMake(5, 20, 5, 5);
    self.messageButton.enabled=NO;

}

@end
