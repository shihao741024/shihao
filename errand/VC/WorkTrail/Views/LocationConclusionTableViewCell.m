//
//  LocationConclusionTableViewCell.m
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "LocationConclusionTableViewCell.h"

@implementation LocationConclusionTableViewCell
{
    UIButton *_button;
    UILabel *_topDescLabel;
    UILabel *_bottomDescLabel;
    
    UILabel *_topCountLabel;
    UILabel *_bottomCountLabel;
    
    UIView *_bottomLine;
    UIView *_middleLine;
    
    UIView *_leftLine;
    UIView *_rightLine;
}
//[UIColor colorWithRed:0.83 green:0.82 blue:0.80 alpha:1.00]
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = COMMON_BACK_COLOR;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, 0, 75, 40);
    _button.titleLabel.font = GDBFont(15);
    _button.userInteractionEnabled = NO;
    [self.contentView addSubview:_button];
    
    _topDescLabel = [self.contentView createGeneralLabel:15 frame:CGRectMake(75+15, 0, kWidth-30-150-15, 40) textColor:COMMON_FONT_BLACK_COLOR];
    _bottomDescLabel = [self.contentView createGeneralLabel:15 frame:CGRectMake(75+15, 40, kWidth-30-150-15, 40) textColor:COMMON_FONT_BLACK_COLOR];
    
    _topCountLabel =  [self.contentView createGeneralLabel:15 frame:CGRectMake(kWidth-30-75, 0, 75, 40) textColor:COMMON_FONT_BLACK_COLOR];
    _topCountLabel.text = @"0";
    _topCountLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomCountLabel =  [self.contentView createGeneralLabel:15 frame:CGRectMake(kWidth-30-75, 40, 75, 40) textColor:COMMON_FONT_BLACK_COLOR];
    _bottomCountLabel.text = @"0";
    _bottomCountLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomLine = [self addLineView:CGRectMake(0, 80, kWidth-30, 0.5)];
    _middleLine = [self addLineView:CGRectMake(75, 40, kWidth-30-75, 0.5)];
    
    _leftLine = [self addLineView:CGRectMake(75, 0, 0.5, 80)];
    _rightLine = [self addLineView:CGRectMake(kWidth-30-75, 0, 0.5, 80)];
    
}

- (UIView *)addLineView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.80 alpha:1.00];
    [self.contentView addSubview:view];
    return view;
}

- (void)fillDescAndTitle:(NSString *)title
{
    if ([title isEqualToString:@"异常"]) {
        [_button setTitle:title forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0.88 green:0.50 blue:0.43 alpha:1.00] forState:UIControlStateNormal];
        
        
        [self bottomViewHide:YES];
        _topDescLabel.text = @"全天未上报";
        _bottomDescLabel.text = @"未接受定位服务";
        
        _bottomLine.hidden = NO;
        
    }else if ([title isEqualToString:@"点不全"]) {
        [_button setTitle:title forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0.46 green:0.25 blue:0.84 alpha:1.00] forState:UIControlStateNormal];
        
        [self bottomViewHide:YES];
        _topDescLabel.text = @"打点不完整";
        
        _bottomLine.hidden = NO;
        
    }else if ([title isEqualToString:@"正常"]) {
        [_button setTitle:title forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0.20 green:0.64 blue:0.41 alpha:1.00] forState:UIControlStateNormal];
        
        [self bottomViewHide:YES];
        _topDescLabel.text = @"正常上报";
        _bottomDescLabel.text = @"不在定位周期";
        
        _bottomLine.hidden = YES;
        
    }
}

- (void)bottomViewHide:(BOOL)hide
{
    _bottomDescLabel.hidden = hide;
    _bottomCountLabel.hidden = hide;
    _middleLine.hidden = hide;
    
    if (hide) {
        _leftLine.frame = CGRectMake(75, 0, 0.5, 40);
        _rightLine.frame = CGRectMake(kWidth-30-75, 0, 0.5, 40);
        _bottomLine.frame = CGRectMake(0, 40, kWidth-30, 0.5);
        _button.frame = CGRectMake(0, 0, 75, 40);
    }else {
        _leftLine.frame = CGRectMake(75, 0, 0.5, 80);
        _rightLine.frame = CGRectMake(kWidth-30-75, 0, 0.5, 80);
        _bottomLine.frame = CGRectMake(0, 80, kWidth-30, 0.5);
        _button.frame = CGRectMake(0, 0, 75, 80);
    }
}

- (void)fillCount:(NSString *)count
{
    _topCountLabel.text = count;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
