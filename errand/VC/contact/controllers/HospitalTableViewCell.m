//
//  HospitalTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "HospitalTableViewCell.h"

@interface HospitalTableViewCell()

@property (nonatomic, copy) void(^selectButtonCB)(HospitalTableViewCell *cell);

@end

@implementation HospitalTableViewCell
{
    UILabel *_nameLabel;
    UILabel *_addressLabel;
    
    UIButton *_selectBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
        self.clipsToBounds = YES;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-50, 0)];
    _nameLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _nameLabel.font = GDBFont(17);
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-50, 0)];
    _addressLabel.textColor = COMMON_FONT_GRAY_COLOR;
    _addressLabel.font = GDBFont(14);
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectBtn.frame = CGRectMake(kWidth-30-30, 5, 30, 30);
    [_selectBtn setImage:[Function getOriginalImage:@"itemchoice_unchecked"] forState:UIControlStateNormal];
    _selectBtn.hidden = YES;
    [_selectBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
}

- (void)selectButtonClick:(UIButton *)button
{
    _selectButtonCB(self);
}

- (void)selectButtonAction:(void (^)(HospitalTableViewCell *))action
{
    _selectButtonCB = action;
}

- (void)fillData:(ContactModel *)model hideSelectBtn:(BOOL)hideSelectBtn
{
    [self hideAllView:NO];
    
    _selectBtn.hidden = hideSelectBtn;
    
    CGFloat theWidth = kWidth-50;
    if (hideSelectBtn) {
        theWidth = kWidth-50;
    }else {
        theWidth = kWidth-50-30;
    }
    
    CGSize nameSize = [Function sizeOfStr:model.hospitalName andFont:GDBFont(17) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
    _nameLabel.text = model.hospitalName;
    _nameLabel.frame = CGRectMake(20, 10, theWidth, nameSize.height);
    
    if ([Function isBlankStrOrNull:model.addressString]) {
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), nameSize.height+20);
        _addressLabel.hidden = YES;
    }else {
        _addressLabel.hidden = NO;
        CGSize addressSize = [Function sizeOfStr:model.addressString andFont:GDBFont(14) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
        _addressLabel.text = model.addressString;
        _addressLabel.frame = CGRectMake(20, kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, theWidth, addressSize.height);
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameY(_addressLabel)+kFrameH(_addressLabel)+10);
    }
    
}

- (void)hideAllView:(BOOL)hide
{
    _nameLabel.hidden = hide;
    _addressLabel.hidden = hide;
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
