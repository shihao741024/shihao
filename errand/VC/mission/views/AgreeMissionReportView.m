//
//  AgreeMissionReportView.m
//  errand
//
//  Created by 医路同行Mac1 on 16/5/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AgreeMissionReportView.h"

@interface AgreeMissionReportView()<UITextFieldDelegate, UITextViewDelegate>
{
    UIButton *_cancelButton;
    UIButton *_reportButton;
    UIButton *_agreeButton;
}
@property (nonatomic, copy) void(^buttonClickCB)(NSInteger);

@end


@implementation AgreeMissionReportView{
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

- (void)uiConfig {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, kWidth-50, 44+110+44)];
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.center = CGPointMake(kFrameW(self)/2.0, kFrameH(self)/2.0);
    [self addSubview:_bgView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-50, 44)];
    topLabel.backgroundColor = COMMON_BLUE_COLOR;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"请输入同意理由";
    [_bgView addSubview:topLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 54, kWidth-50-30, 100)];
    _textView.delegate = self;
    _textView.text = @"同意";
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = COMMON_FONT_BLACK_COLOR.CGColor;
    _textView.layer.cornerRadius = 5;
    _textView.font = GDBFont(15);
    [_bgView addSubview:_textView];
    
    CGFloat btnW = (kWidth-50)/3.0;
    _cancelButton = [self addButtonFrame:CGRectMake(0, 44+110, btnW, 44) titleColor:COMMON_FONT_BLACK_COLOR title:@"取消"];
    _reportButton = [self addButtonFrame:CGRectMake(btnW, 44+110, btnW, 44) titleColor:COMMON_BLUE_COLOR title:@"审批并上报"];
    _agreeButton = [self addButtonFrame:CGRectMake(btnW*2, 44+110, btnW, 44) titleColor:kGreenColor title:@"审批通过"];
}

- (void)buttonClick:(UIButton *)button
{
    [_textView resignFirstResponder];
    
    if (button == _cancelButton) {
        
        _buttonClickCB(0);
        
    }else if (button == _reportButton) {
        
        _buttonClickCB(1);
    }else if (button == _agreeButton) {
        if ([_textView.text isEqualToString:@""]) {
            [Dialog simpleToast:@"理由不能为空"];
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


@end
