//
//  SubordinateDateSelectView.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SubordinateDateSelectView.h"

@implementation SubordinateDateSelectView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_titleLabel;
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
    _leftButton = [self createButtonImg:[Function getOriginalImage:@"leftBtn"] frame:CGRectMake(20, 0, 40, kFrameH(self))];
    
    _rightButton = [self createButtonImg:[Function getOriginalImage:@"rightBtn"] frame:CGRectMake(kFrameW(self)-20-40, 0, 40, kFrameH(self))];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+40, 0, kFrameW(self)-(20+40)*2, kFrameH(self))];
    _titleLabel.textColor = COMMON_BLUE_COLOR;
    _titleLabel.text = @"今天";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (UIButton *)createButtonImg:(UIImage *)img frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = frame;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    if (button == _leftButton) {
        _seletedDateCB(@"left");
    }else {
        _seletedDateCB(@"right");
    }
    
}

- (void)seletedDateAction:(void (^)(NSString *))action
{
    _seletedDateCB = [action copy];
}

- (void)reloadTitle:(NSString *)title
{
    _titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
