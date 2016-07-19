//
//  ContactsViewCell.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ContactsViewCell.h"

@interface ContactsViewCell()
@property (nonatomic, copy) void(^selectButtonCB)(ContactsViewCell *cell);
@end

@implementation ContactsViewCell
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
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-40, 0)];
    _nameLable.textColor = COMMON_FONT_BLACK_COLOR;
    _nameLable.font = GDBFont(20);
    _nameLable.numberOfLines = 0;
    [self.contentView addSubview:_nameLable];
    
    _addressLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-40, 0)];
    _addressLable.textColor = COMMON_FONT_GRAY_COLOR;
    _addressLable.font = GDBFont(15);
    _addressLable.numberOfLines = 0;
    [self.contentView addSubview:_addressLable];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectBtn.frame = CGRectMake(kWidth-50, 10, 40, 40);
//    _selectBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_selectBtn setImage:[Function getOriginalImage:@"itemchoice_unchecked"] forState:UIControlStateNormal];
    _selectBtn.hidden = YES;
    [_selectBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kFrameH(_nameLable)+kFrameH(_addressLable), SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    [self.contentView addSubview:lineLabel];
}

- (void)fillData:(ContactModel *)model
{
    [self hideAllView:NO];
    CGFloat theWidth = kWidth-40;
    
    CGSize nameSize = [Function sizeOfStr:model.hospitalName andFont:GDBFont(20) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
    _nameLable.text = model.hospitalName;
    _nameLable.frame = CGRectMake(20, 15, theWidth, nameSize.height);
    
    if ([Function isBlankStrOrNull:model.addressString]) {
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), nameSize.height+30);
        _addressLable.hidden = YES;
    }else {
        _addressLable.hidden = NO;
        CGSize addressSize = [Function sizeOfStr:model.addressString andFont:GDBFont(15) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
        _addressLable.text = model.addressString;
        _addressLable.frame = CGRectMake(20, kFrameY(_nameLable)+kFrameH(_nameLable)+10, theWidth, addressSize.height);
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameY(_addressLable)+kFrameH(_addressLable)+15);
    }
}

/*====================*/
- (void)selectButtonClick:(UIButton *)button
{
    _selectButtonCB(self);
}
- (void)selectButtonAction:(void (^)(ContactsViewCell *))action
{
    _selectButtonCB = action;
}
- (void)fillData:(ContactModel *)model hideSelectBtn:(BOOL)hideSelectBtn
{
    [self hideAllView:NO];
    _selectBtn.hidden = hideSelectBtn;
    
    CGFloat theWidth = kWidth-40;
    if (hideSelectBtn) {
        theWidth = kWidth-40;
    }else {
        theWidth = kWidth-40-30;
    }
    CGSize nameSize = [Function sizeOfStr:model.hospitalName andFont:GDBFont(20) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
    _nameLable.text = model.hospitalName;
    _nameLable.frame = CGRectMake(20, 15, theWidth, nameSize.height);
    
    if ([Function isBlankStrOrNull:model.addressString]) {
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), nameSize.height+30);
        _addressLable.hidden = YES;
    }else {
        _addressLable.hidden = NO;
        CGSize addressSize = [Function sizeOfStr:model.addressString andFont:GDBFont(15) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
        _addressLable.text = model.addressString;
        _addressLable.frame = CGRectMake(20, kFrameY(_nameLable)+kFrameH(_nameLable)+10, theWidth, addressSize.height);
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameY(_addressLable)+kFrameH(_addressLable)+15);
    }
}
/*====================*/


- (void)hideAllView:(BOOL)hide
{
    _nameLable.hidden = hide;
    _addressLable.hidden = hide;
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
