//
//  WjjStaffTableViewCell.m
//  errand
//
//  Created by Apple on 15/12/13.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "StaffTableViewCell.h"

@implementation StaffTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSInteger)type {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        switch (type) {
            case 0:
                break;
            case 1: {
                [self createCell];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)createCell {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textColor = COMMON_FONT_BLACK_COLOR;
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    phoneNumLabel.font = [UIFont systemFontOfSize:15];
    phoneNumLabel.textColor = COMMON_FONT_GRAY_COLOR;
    self.phoneNumLabel = phoneNumLabel;
    [self addSubview:self.phoneNumLabel];
    
    UIButton *stateBtn = [[UIButton alloc] init];
    [stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.stateBtn = stateBtn;
    [self addSubview:self.stateBtn];
    
    
    
    
    // 适配
    UIView *superView = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(5);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(-5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10+44+10);
        make.top.equalTo(bgView.mas_top).offset(10);
        make.width.equalTo(@300);
        //        make.height.equalTo(bgView).multipliedBy(30/50.0);
        make.bottom.equalTo(self.phoneNumLabel.mas_top).offset(0);
    }];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10+44+10);
        make.bottom.equalTo(bgView.mas_bottom).offset(-10);
        make.width.equalTo(@300);
        make.height.equalTo(self.nameLabel).multipliedBy(3/5.0);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(superView.mas_right).offset(-25);
        make.width.equalTo(@30);
        make.height.equalTo(@60);
    }];
    
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (60-44)/2.0, 44, 44)];
//    _iconImgView.backgroundColor = [UIColor cyanColor];
    _iconImgView.layer.cornerRadius = 22;
    _iconImgView.clipsToBounds = YES;
    [bgView addSubview:_iconImgView];
    _iconImgView.image = [UIImage imageNamed:@"headerImg_default"];
}

- (void)stateBtnClick:(UIButton *)btn {
    self.callPhoneBlock();
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
