//
//  VisitDetailSubTitleTableViewCell.m
//  errand
//
//  Created by pro on 16/4/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitDetailSubTitleTableViewCell.h"


@implementation VisitDetailSubTitleTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    
    CornerBgView *_bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _bgView = [[CornerBgView alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 50) cornerStyle:CornerNone cornerRadius:10];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [_bgView createGeneralLabel:15 frame:CGRectMake(30, 10, kFrameW(_bgView)-30, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _detailLabel = [_bgView createGeneralLabel:15 frame:CGRectMake(30, kFrameY(_titleLabel)+kFrameH(_titleLabel)+10, kFrameW(_bgView)-40, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _detailLabel.numberOfLines = 0;
    
}

- (void)fillDataWithTitle:(NSString *)title detail:(NSString *)detail cornerStyle:(CornerStyle)cornerStyle
{
    _titleLabel.text = title;
    
    _detailLabel.text = detail;
    CGSize size = [Function sizeOfStr:detail andFont:_detailLabel.font andMaxSize:CGSizeMake(kFrameW(_detailLabel), CGFLOAT_MAX)];
    _detailLabel.frame = CGRectMake(kFrameX(_detailLabel), kFrameY(_detailLabel), kFrameW(_detailLabel), size.height);
    
    _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), kFrameY(_detailLabel)+kFrameH(_detailLabel)+10);
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameH(_bgView));
    
    [_bgView handleSetNeedsLayoutWithStyle:cornerStyle];
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
