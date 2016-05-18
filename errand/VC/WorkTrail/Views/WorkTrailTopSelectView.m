//
//  WorkTrailTopSelectView.m
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "WorkTrailTopSelectView.h"

@interface WorkTrailTopSelectView()

@property (nonatomic, copy) void(^selectIndexCB)(NSInteger index);

@end

@implementation WorkTrailTopSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btnArray = [NSMutableArray array];
        _lineArray = [NSMutableArray array];
        
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, kWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    CGFloat btnW = kWidth/3.0;
    NSArray *btnTitleArray = @[@"实时位置", @"位置分布", @"定位总结"];
    for (NSInteger i=0; i<btnTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+ i;
        button.frame = CGRectMake(i*btnW, 0, btnW, 42);
        button.titleLabel.font = GDBFont(15);
        [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*btnW, 40, btnW, 2)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        if (i == 0) {
            button.selected = YES;
            view.backgroundColor = COMMON_BLUE_COLOR;
        }
        
        [_lineArray addObject:view];
        [_btnArray addObject:button];
    }
    
}

- (void)headButtonClick:(UIButton *)button
{
    _selectIndexCB(button.tag);
    
    [self changeButtonStatus:button.tag];
    
}

- (void)changeButtonStatus:(NSInteger)index
{
    for (NSInteger i=0; i<_btnArray.count; i++) {
        UIButton *button = _btnArray[i];
        UIView *view = _lineArray[i];
        button.selected = NO;
        view.backgroundColor = [UIColor clearColor];
        
        if (button.tag == index) {
            button.selected = YES;
            view.backgroundColor = COMMON_BLUE_COLOR;
        }
    }
    
}

- (void)selectIndexAction:(void(^)(NSInteger index))action
{
    _selectIndexCB = action;
}

- (void)setSelectButton:(NSInteger)index
{
    [self changeButtonStatus:index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
