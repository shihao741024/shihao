//
//  FillVisitLabelTableViewCell.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "FillVisitLabelTableViewCell.h"

@interface FillVisitLabelTableViewCell()

@property (nonatomic, copy) void(^buttonClickCB)(FillVisitLabelTableViewCell *currentCell);
@property (nonatomic, copy) void(^contentTapCB)(FillVisitLabelTableViewCell *currentCell);

@end

@implementation FillVisitLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = COMMON_FONT_GRAY_COLOR;
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, kWidth-105, 44)];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = COMMON_FONT_GRAY_COLOR;
    _contentLabel.userInteractionEnabled = YES;
    [_contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelTap:)]];
    [self.contentView addSubview:_contentLabel];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clearButton.frame = CGRectMake(kWidth-40, 2, 40, 40);
    [_clearButton setImage:[Function getOriginalImage:@"clear_text"] forState:UIControlStateNormal];
    [_clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.hidden = YES;
    [self.contentView addSubview:_clearButton];
}

- (void)clearButtonClick:(UIButton *)button
{
    _clearButton.hidden = YES;
    _contentLabel.text = @"";
    _buttonClickCB(self);
}

- (void)clearButtonClickAction:(void (^)(FillVisitLabelTableViewCell *))action
{
    _buttonClickCB = action;
}

- (void)contentLabelTap:(UITapGestureRecognizer *)tap
{
    _contentTapCB(self);
}

- (void)contentLabelTapAction:(void (^)(FillVisitLabelTableViewCell *))action
{
    _contentTapCB = action;
}

- (void)fillContent:(NSString *)content placeholder:(NSString *)placeholder
{
    if ([content isEqualToString:@""]) {
        _clearButton.hidden = YES;
        _contentLabel.text = placeholder;
        _contentLabel.textColor = COMMON_FONT_GRAY_COLOR;
    }else {
        if ([placeholder isEqualToString:@"请选择携访人"]) {
            _clearButton.hidden = NO;
        }else {
            _clearButton.hidden = YES;
        }
        _contentLabel.text = content;
        _contentLabel.textColor = COMMON_FONT_BLACK_COLOR;
    }
}

- (void)searchVisitRecordFillContent:(NSString *)content placeholder:(NSString *)placeholder
{
    if ([content isEqualToString:@""]) {
        _clearButton.hidden = YES;
        _contentLabel.text = placeholder;
        _contentLabel.textColor = COMMON_FONT_GRAY_COLOR;
    }else {
        _clearButton.hidden = NO;
        _contentLabel.text = content;
        _contentLabel.textColor = COMMON_FONT_BLACK_COLOR;
    }
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
