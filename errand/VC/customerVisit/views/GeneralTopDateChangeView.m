//
//  GeneralTopDateChangeView.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "GeneralTopDateChangeView.h"

@interface GeneralTopDateChangeView()

//type == 0 今天，-1上一个， 1下一个
@property (nonatomic, copy) void(^buttonClickCB)(NSInteger type);

@end

@implementation GeneralTopDateChangeView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    
}

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
    self.backgroundColor = [UIColor whiteColor];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _leftButton.frame = CGRectMake(50, 0, 30, kFrameH(self));
    [_leftButton setImage:[Function getOriginalImage:@"leftBtn"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightButton.frame = CGRectMake(kFrameW(self)-50-30, 0, 30, kFrameH(self));
    [_rightButton setImage:[Function getOriginalImage:@"rightBtn"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    _todayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _todayButton.frame = CGRectMake(kFrameW(self)-10-30, 0, 30, kFrameH(self));
    [_todayButton setImage:[Function getOriginalImage:@"todayBtn"] forState:UIControlStateNormal];
    [_todayButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_todayButton];
    
    _titleLabel = [self createGeneralLabel:15 frame:CGRectMake(80, 0, kWidth-160, kFrameH(self)) textColor:COMMON_FONT_GRAY_COLOR];
    _titleLabel.textColor = COMMON_BLUE_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)buttonClick:(UIButton *)button
{
    if (button == _leftButton) {
        _buttonClickCB(-1);
    }else if (button == _rightButton) {
        _buttonClickCB(1);
    }else {
        _buttonClickCB(0);
    }
    
}

- (void)buttonClickAction:(void(^)(NSInteger type))action
{
    _buttonClickCB = action;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
