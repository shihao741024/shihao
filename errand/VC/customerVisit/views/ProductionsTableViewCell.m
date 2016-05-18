//
//  ProductionsTableViewCell.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ProductionsTableViewCell.h"

@implementation ProductionsTableViewCell
{
    UILabel *_detailLabel;
    UILabel *_nameLabel;
    UILabel *_sizeLabel;
    
    UILabel *_companyLabel;
    UIView *_bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, kWidth-30, 0)];
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:_bgView];
    
    _detailLabel = [_bgView createGeneralLabel:14 frame:CGRectMake(15, 10, kFrameW(_bgView)-30, 0) textColor:COMMON_FONT_BLACK_COLOR];
    _detailLabel.numberOfLines = 0;
    
    _nameLabel = [_bgView createGeneralLabel:17 frame:CGRectMake(15, kFrameY(_detailLabel)+kFrameH(_detailLabel)+10, kFrameW(_bgView)-30, 0) textColor:COMMON_BLUE_COLOR];
    _nameLabel.numberOfLines = 0;
    
    _sizeLabel = [_bgView createGeneralLabel:14 frame:CGRectMake(15, kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, kFrameW(_bgView)-30, 0) textColor:COMMON_FONT_BLACK_COLOR];
    _sizeLabel.numberOfLines = 0;
    
    _companyLabel = [_bgView createGeneralLabel:14 frame:CGRectMake(15, kFrameY(_sizeLabel)+kFrameH(_sizeLabel)+10, kFrameW(_bgView)-30, 0) textColor:COMMON_FONT_GRAY_COLOR];
    _companyLabel.numberOfLines = 0;
}

- (void)hideAllView:(BOOL)hide
{
    _bgView.hidden = hide;
    _detailLabel.hidden = hide;
    _nameLabel.hidden = hide;
    
    _sizeLabel.hidden = hide;
    _companyLabel.hidden = hide;
}

- (void)fillData:(ProductionModel *)model;
{
    [self hideAllView:NO];
    
    _detailLabel.text = model.detail;
    CGSize detailSize = [Function sizeOfStr:_detailLabel.text andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_detailLabel), CGFLOAT_MAX)];
    _detailLabel.frame = CGRectMake(kFrameX(_detailLabel), kFrameY(_detailLabel), kFrameW(_detailLabel), detailSize.height);
   
    
    _nameLabel.text = model.name;
    CGSize nameSize = [Function sizeOfStr:_nameLabel.text andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_nameLabel), CGFLOAT_MAX)];
    _nameLabel.frame = CGRectMake(15, kFrameY(_detailLabel)+kFrameH(_detailLabel)+10, kFrameW(_bgView)-30, nameSize.height);

    
    if ([Function isBlankStrOrNull:model.packageUnit]) {
        _sizeLabel.text = model.specification;
    }else {
        _sizeLabel.text = [NSString stringWithFormat:@"%@ / %@", model.specification, model.packageUnit];
    }
    
    CGSize sizeSize = [Function sizeOfStr:_sizeLabel.text andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_sizeLabel), CGFLOAT_MAX)];
    _sizeLabel.frame = CGRectMake(15, kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, kFrameW(_bgView)-30, sizeSize.height);
    
    _companyLabel.text = model.vendor;
    CGSize companySize = [Function sizeOfStr:_companyLabel.text andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_companyLabel), CGFLOAT_MAX)];
    _companyLabel.frame = CGRectMake(15, kFrameY(_sizeLabel)+kFrameH(_sizeLabel)+10, kFrameW(_bgView)-30, companySize.height);
    
    _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), kFrameY(_companyLabel)+kFrameH(_companyLabel)+10);
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameY(_bgView)+kFrameH(_bgView)+10);
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
