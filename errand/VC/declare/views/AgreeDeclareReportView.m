//
//  AgreeDeclareReportView.m
//  errand
//
//  Created by 高道斌 on 16/4/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AgreeDeclareReportView.h"

@interface AgreeDeclareReportView()<UITextFieldDelegate, UITextViewDelegate>
{
    UIButton *_cancelButton;
    UIButton *_reportButton;
    UIButton *_agreeButton;
}
@property (nonatomic, copy) void(^buttonClickCB)(NSInteger);

@end

@implementation AgreeDeclareReportView
{
    UIView *_bgView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self uiConfig];
    }
    return self;
}

- (void)buttonClickAction:(void(^)(NSInteger index))action
{
    _buttonClickCB = action;
}

- (void)uiConfig
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, kWidth-50, 44+50+100+44)];
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    [self addSubview:_bgView];
    
    _bgView.center = CGPointMake(kFrameW(self)/2.0, kFrameH(self)/2.0);
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-50, 44)];
    topLabel.backgroundColor = COMMON_BLUE_COLOR;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"审批意见";
    [_bgView addSubview:topLabel];
    
    UILabel *label = [self createGeneralLabel:14 frame:CGRectMake(15, 44, 80, 50) textColor:COMMON_FONT_GRAY_COLOR];
    label.text = @"费用金额：";
    [_bgView addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 44, kWidth-170, 50)];
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.font = GDBFont(15);
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [_bgView addSubview:_textField];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(100, 44+40, kWidth-170, 0.5)];
    lineV.backgroundColor = COMMON_FONT_BLACK_COLOR;
    [_bgView addSubview:lineV];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 50+44, kWidth-50-30, 100)];
    _textView.delegate = self;
    _textView.text = @"同意";
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = COMMON_FONT_BLACK_COLOR.CGColor;
    _textView.layer.cornerRadius = 5;
    _textView.font = GDBFont(15);
    [_bgView addSubview:_textView];
    
    CGFloat btnW = (kWidth-50)/3.0;
    _cancelButton = [self addButtonFrame:CGRectMake(0, 50+44+100, btnW, 44) titleColor:COMMON_FONT_BLACK_COLOR title:@"取消"];
    _reportButton = [self addButtonFrame:CGRectMake(btnW, 50+44+100, btnW, 44) titleColor:COMMON_BLUE_COLOR title:@"审批并上报"];
    _agreeButton = [self addButtonFrame:CGRectMake(btnW*2, 50+44+100, btnW, 44) titleColor:kGreenColor title:@"审批通过"];
    
}

- (void)buttonClick:(UIButton *)button
{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
    
    if (button == _cancelButton) {
        
        _buttonClickCB(0);
        
    }else if (button == _reportButton) {
        if ([_textField.text isEqualToString:@""]) {
            [Dialog simpleToast:@"金额不能为空"];
            return;
        }
        _buttonClickCB(1);
    }else if (button == _agreeButton) {
        if ([_textField.text isEqualToString:@""]) {
            [Dialog simpleToast:@"金额不能为空"];
            return;
        }
        _buttonClickCB(2);
    }
    self.hidden = YES;
}

- (UIButton *)addButtonFrame:(CGRect)frame titleColor:(UIColor *)titleColor title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [_bgView addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
