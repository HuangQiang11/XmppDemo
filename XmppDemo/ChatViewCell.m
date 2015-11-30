//
//  ChatViewCell.m
//  iGathering
//
//  Created by TTL on 15/5/5.
//  Copyright (c) 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.layer.cornerRadius=15;
    self.icon.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setdata:(id)model{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.timeLable.text = nil;
    self.namelable.text = nil;
    self.timeLable.text = [NSString stringYMDHMSFromDate:(NSDate *)[model valueForKey:@"timestamp"]];
    CGRect rect = [[model valueForKey:@"body"] boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
    CGFloat contentX = IPHONE_WIDTH-40-rect.size.width-35;
    UIImage * image = [UIImage imageNamed:@"blue"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.7];
    [self.messageButton setBackgroundImage:image forState:UIControlStateNormal];
    self.messageButton.frame = CGRectMake(contentX,30, rect.size.width+30, rect.size.height+30);
    self.messageButton.titleLabel.numberOfLines = 0;
    [self.messageButton setTitle:[model valueForKey:@"body"] forState:UIControlStateNormal];
    self.messageButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 20);
    self.messageButton.enabled = NO;
}

- (void)setDataForGroup:(ChatModel *)model{
    self.timeLable.text=nil;
    self.namelable.text=nil;
    self.timeLable.text=model.time;
    self.namelable.text=model.name;
    CGRect rect=[model.message boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName ,nil] context:nil];
    CGFloat contentX=IPHONE_WIDTH-40-rect.size.width-35;
    
    UIImage * image=[UIImage imageNamed:@"blue"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.7];
    [self.messageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.messageButton.frame=CGRectMake(contentX,30, rect.size.width+30, rect.size.height+30);
    self.messageButton.titleLabel.numberOfLines=0;
    [self.messageButton setTitle:model.message forState:UIControlStateNormal];
    self.messageButton.titleEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 20);
    self.messageButton.enabled=NO;

}

@end
