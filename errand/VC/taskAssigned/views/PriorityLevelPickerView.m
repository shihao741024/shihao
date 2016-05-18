//
//  PriorityLevelPickerView.m
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "PriorityLevelPickerView.h"

@implementation PriorityLevelPickerView {
    
    UIPickerView      *_picker;
    NSMutableArray    *_pickerArray;
    NSMutableString   *_feedBackString;
    UIView            *_view;
}

#pragma  mark - function

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _pickerArray = [NSMutableArray arrayWithArray:@[@"低", @"中", @"高"]];
        self.backgroundColor = [UIColor whiteColor];
        [self createBtns];
        [self createPickerView];
    }
    return self;
}


- (void)createView {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.3;
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    _view.backgroundColor = [UIColor whiteColor];
    _view.alpha = 1;
    [self addSubview:_view];
    [self createBtns];
    [self createPickerView];
}

- (void)createBtns {
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 40, 30)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    
}

- (void)cancelBtnClick {
    self.feedBack(self.currentString);
    [self removeFromSuperview];
}

- (void)submitBtnClick {
    self.feedBack(self.feedBackString);
    [self removeFromSuperview];
}

#pragma mark - 选择器
- (void)createPickerView {
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    self.feedBackString = [NSMutableString stringWithString:_pickerArray[0]];
    [self addSubview:_picker];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArray.count;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"picker    %@", _pickerArray[row]);
    self.feedBackString = [NSMutableString stringWithString:_pickerArray[row]];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerArray[row];
}

@end
