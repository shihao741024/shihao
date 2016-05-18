//
//  MMDateView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMDateView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "Masonry/Masonry.h"

@interface MMDateView()

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;


@end

@implementation MMDateView


- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        
        [self.btnCancel setTitleColor:COMMON_LIGHT_COLOR forState:UIControlStateNormal];
        
        [self.btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
        _centerLabel.textColor = COMMON_LIGHT_COLOR;
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_centerLabel];
        
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 50));
            make.left.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionChoice)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        
        [self.btnConfirm setTitleColor:COMMON_LIGHT_COLOR forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.datePicker = [UIDatePicker new];
        [self addSubview:self.datePicker];
        
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
        
        
        
    }
    
    return self;
}
- (void)actionChoice
{
    
    [self.delegate MMChoiceDateViewChoiced:_datePicker];
    [self hide];
}

- (void)actionHide
{
    [self hide];
}

@end
