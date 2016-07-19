//
//  RejectDeclareReportView.m
//  errand
//
//  Created by 医路同行Mac1 on 16/5/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "RejectDeclareReportView.h"

@interface RejectDeclareReportView()<UITextFieldDelegate, UITextViewDelegate>{
    UIButton *_cancelButton;
    UIButton *_sureButton;
}
@property (nonatomic, copy) void(^buttonClickCB)(NSInteger);

@end

@implementation RejectDeclareReportView{
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
    topLabel.text = @"请输入拒绝理由";
    [_bgView addSubview:topLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 54, kWidth-50-30, 100)];
    _textView.delegate = self;
    _textView.text = @"";
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = COMMON_FONT_BLACK_COLOR.CGColor;
    _textView.layer.cornerRadius = 5;
    _textView.font = GDBFont(15);
    [_bgView addSubview:_textView];
    
    CGFloat btnW = (kWidth-50)/2.0;
    _cancelButton = [self addButtonFrame:CGRectMake(0, 44+110, btnW, 44) titleColor:COMMON_BLUE_COLOR title:@"取消"];
    _sureButton = [self addButtonFrame:CGRectMake(btnW, 44+110, btnW, 44) titleColor:kGreenColor title:@"确定"];
}

- (void)buttonClick:(UIButton *)button
{
    [_textView resignFirstResponder];
    
    if (button == _cancelButton) {
        
        _buttonClickCB(0);
        
    }else if (button == _sureButton) {
        if ([_textView.text isEqualToString:@""]) {
            [Dialog simpleToast:@"理由不能为空"];
            return;
        }
        _buttonClickCB(1);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
