//
//  MassageAndPhoneView.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MassageAndPhoneView.h"

@interface MassageAndPhoneView()
{
    UIButton *_msgButton;
    UIButton *_phoneButton;
}

@property (nonatomic, copy) void(^msgOrPhoneClickCB)(NSInteger type);

@end

@implementation MassageAndPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _msgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _msgButton.frame = CGRectMake((kWidth-70*2)/3.0, 10, 70, 70);
    [_msgButton setImage:[Function getOriginalImage:@"message_selected"] forState:UIControlStateNormal];
    [_msgButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgButton];
    
    
    _phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneButton.frame = CGRectMake((kWidth-70*2)/3.0*2+70, 10, 70, 70);
    [_phoneButton setImage:[Function getOriginalImage:@"phone_big"] forState:UIControlStateNormal];
    [_phoneButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_phoneButton];
    
}

- (void)buttonClick:(UIButton *)button
{
    if (button == _msgButton) {
        _msgOrPhoneClickCB(1);
    }else {
        _msgOrPhoneClickCB(0);
    }
}

- (void)msgOrPhoneClickAction:(void(^)(NSInteger type))action
{
    _msgOrPhoneClickCB = action;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
