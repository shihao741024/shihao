//
//  TrailCheckView.m
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TrailCheckView.h"


@interface TrailCheckView()

@property (nonatomic, copy) void(^buttonClickCB)(NSInteger, BOOL);

@end

@implementation TrailCheckView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        [self uiConfig];
    }
    return self;
}
//125 90
- (void)uiConfig
{
    UILabel *topLabel = [self createGeneralLabel:15 frame:CGRectMake(0, 0, 125-45, 45) textColor:COMMON_FONT_BLACK_COLOR];
    topLabel.text = @"自由打卡";
    topLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *bottomLabel = [self createGeneralLabel:15 frame:CGRectMake(0, 45, 125-45, 45) textColor:COMMON_FONT_BLACK_COLOR];
    bottomLabel.text = @"客户拜访";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    _topButton = [self createButtonFrame:CGRectMake(125-45, 0, 45, 45)];
    _bottomButton = [self createButtonFrame:CGRectMake(125-45, 45, 45, 45)];
}

- (UIButton *)createButtonFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"trail_check_no"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"trail_check_se"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button == _topButton) {
        _buttonClickCB(0, button.selected);
    }else if (button == _bottomButton) {
        _buttonClickCB(1, button.selected);
    }
}

- (void)buttonClickAction:(void(^)(NSInteger type, BOOL selected))action
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
