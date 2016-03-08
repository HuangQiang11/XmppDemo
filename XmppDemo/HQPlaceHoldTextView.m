//
//  HQPlaceHoldTextView.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 16/3/7.
//  Copyright © 2016年 Transaction Technologies Limited. All rights reserved.
//

#import "HQPlaceHoldTextView.h"

@implementation HQPlaceHoldTextView{
    UIColor * originalColor;
}
- (void)awakeFromNib{
    [self setLayout];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
    self.delegate = self;
    [self setHQTextColor:[UIColor blackColor]];
    self.placeholderColor = [UIColor lightGrayColor];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.textColor = placeholderColor;
}

- (void)setHQTextColor:(UIColor *)color{
    originalColor = color;
    self.textColor = color;
}

#pragma mark UITextFieldDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.textColor == self.placeholderColor) {
        textView.text = @"";
        textView.textColor = originalColor;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholder;
        textView.textColor = self.placeholderColor;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
