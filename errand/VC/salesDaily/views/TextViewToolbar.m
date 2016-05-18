//
//  TextViewToolbar.m
//  errand
//
//  Created by 高道斌 on 16/4/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TextViewToolbar.h"

@implementation TextViewToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _atButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _atButton.frame = CGRectMake(10, 10, 30, 30);
        [_atButton setImage:[UIImage imageNamed:@"aboutOther"] forState:UIControlStateNormal];
        [self addSubview:_atButton];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sendButton.frame = CGRectMake(kWidth-50-5-5, 8, 50, 34);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = GDBFont(15);
        _sendButton.backgroundColor = [UIColor colorWithRed:0.42 green:0.77 blue:0.99 alpha:1.00];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sendButton];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 8, kWidth-50-60, 50-16)];
        _textView.layer.backgroundColor = COMMON_FONT_GRAY_COLOR.CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        [self addSubview:_textView];
        
        
//        [_textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
