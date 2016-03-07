//
//  HQPlaceHoldTextView.h
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/7.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQPlaceHoldTextView : UITextView<UITextViewDelegate>
@property (copy, nonatomic) NSString * placeholder;
@property (strong, nonatomic) UIColor * placeholderColor;
- (void)setHQTextColor:(UIColor *)color;
@end
