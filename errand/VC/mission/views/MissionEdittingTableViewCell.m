//
//  MissionEdittingTableViewCell1.m
//  errand
//
//  Created by gravel on 16/1/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MissionEdittingTableViewCell.h"

@implementation MissionEdittingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
- (void)createCell {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = COMMON_FONT_BLACK_COLOR;
    nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel = detailLabel;
    self.detailLabel.textColor = COMMON_FONT_BLACK_COLOR;
    [self addSubview:self.detailLabel];
    
    // 适配
    UIView *superView = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(15);
        make.right.equalTo(self.detailLabel.mas_left).offset(0);
        make.top.equalTo(superView.mas_top).offset(10);
        //        make.centerY.equalTo(superView);
        make.width.equalTo(@85);
        //                make.height.equalTo(@30);
        
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
        
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(superView);
        make.top.equalTo(superView.mas_top).offset(0);
        make.right.equalTo(superView.mas_right).offset(0);
        //                make.height.equalTo(superView.height - 20);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
    }];
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.textColor = COMMON_FONT_BLACK_COLOR;
//    nameLabel.font = [UIFont systemFontOfSize:14];
//    self.nameLabel = nameLabel;
//    [self addSubview:self.nameLabel];
//    
//    
//    // 适配
//    UIView *superView = self;
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.mas_left).offset(15);
//        make.top.equalTo(superView.mas_top).offset(0);
//        make.width.equalTo(@85);
//        make.bottom.equalTo(superView.mas_bottom).offset(0);
//        
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end