//
//  DepartmentView.m
//  errand
//
//  Created by gravel on 16/3/1.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DepartmentView.h"

@implementation DepartmentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        topLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [self addSubview:topLabel];
        
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, SCREEN_WIDTH, 1)];
        bottomLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [self addSubview:bottomLabel];
        
        UIImageView *locationView = [[UIImageView alloc]init];
        _departmentImgView = locationView;
        _departmentImgView.image = [UIImage imageNamed:@"department"];
        [self addSubview:_departmentImgView];
        
        UILabel *locationLabel = [[UILabel alloc]init];
        locationLabel.textColor = COMMON_FONT_BLACK_COLOR;
        _departmentLabel = locationLabel;
        _departmentLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapter:15]];
        _departmentLabel.textAlignment = NSTextAlignmentLeft;
        _departmentLabel.text = @"按部门选择";
        [self addSubview:_departmentLabel];
        
        [_departmentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.height.equalTo(30);
            make.width.equalTo(30);
        }];
        [_departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_departmentImgView.mas_right).offset(10);
            make.height.equalTo([MyAdapter aDapterView:60]);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
       
    }
    return self;
}

@end
