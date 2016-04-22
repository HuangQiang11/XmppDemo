//
//  PlaceholdTextView.m
//  PlaceholdTextView
//
//  Created by ttlgz-0022 on 16/3/22.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "PlaceholdTextView.h"
@interface PlaceholdTextView()

@property (weak, nonatomic) UILabel * placeholdLabel;

@end

@implementation PlaceholdTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UILabel * placeholdLabel = [[UILabel alloc] init];
    placeholdLabel.backgroundColor = [UIColor clearColor];
    placeholdLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:placeholdLabel];
    self.placeholdLabel = placeholdLabel;
    self.placeholdColor = [UIColor colorWithRed:177/255.0 green:186/255.0 blue:184/255.0 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.placeholdLabel.frame = CGRectMake(5, 0, CGRectGetWidth(self.frame) -10, 21);
}

- (void)textChange{
    self.placeholdLabel.hidden = self.hasText;
}

- (void)setPlacehold:(NSString *)placehold{
    _placehold = placehold;
    self.placeholdLabel.text = placehold;
}

- (void)setPlaceholdColor:(UIColor *)placeholdColor{
    _placeholdColor = placeholdColor;
    self.placeholdLabel.textColor = placeholdColor;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
