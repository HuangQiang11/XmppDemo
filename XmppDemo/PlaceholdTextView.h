//
//  PlaceholdTextView.h
//  PlaceholdTextView
//
//  Created by ttlgz-0022 on 16/3/22.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholdTextView : UITextView
@property (copy, nonatomic) NSString * placehold;
@property (strong, nonatomic) UIColor * placeholdColor;
@end
