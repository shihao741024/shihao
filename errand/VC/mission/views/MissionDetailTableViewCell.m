//
//  MissionDetailTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionDetailTableViewCell.h"

@implementation MissionDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
- (void)createCell{
    self.orderLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.nameLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.stateLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter];
    self.dateLabel = [self createLabelWithFont:17 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentRight];
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    [self.contentView addSubview:self.lineLabel];
    self.reasonLabel = [self createLabelWithFont:17 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentLeft];
    
    UIView *superView = self;
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
        make.width.equalTo(@20);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(0);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(self.stateLabel.mas_left).offset(-5);
        make.height.equalTo(@20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateLabel.mas_left).offset(-10);
        make.top.equalTo(superView.mas_top).offset(10);
        make.height.equalTo(@20);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-10);
        make.top.equalTo(superView.mas_top).offset(10);
        make.height.equalTo(@20);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(0);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.right.equalTo(superView.mas_right).offset(0);
        make.height.equalTo(@1);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(0);
        make.top.equalTo(self.lineLabel.mas_bottom).offset(10);
        make.right.equalTo(superView.mas_right).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    }];
    
}
- (void)setModel{
    self.orderLabel.text = @"1";
    self.nameLabel.text = @"上级大领导";
    self.stateLabel.text = @"批准申请";
    CGSize size1 = [self sizeWithString:self.stateLabel.text font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.stateLabel.width = size1.width;
    self.dateLabel.text = @"2015.12.20";
    CGSize size = [self sizeWithString:self.dateLabel.text font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.dateLabel.width = size.width;
    self.reasonLabel.numberOfLines = 0;
    self.reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.reasonLabel.text = @"原因内容7原因内容";
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [self.contentView addSubview:label];
    return label;
}
#pragma mark - 计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
