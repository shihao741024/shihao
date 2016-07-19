//
//  DoctorsViewCell.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorsViewCell.h"

@implementation DoctorsViewCell

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
    _nameLable.font = GDBFont(18);
    _nameLable.numberOfLines = 0;
    [self.contentView addSubview:_nameLable];
    
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-40, 0)];
    _contentLable.textColor = COMMON_FONT_GRAY_COLOR;
    _contentLable.font = GDBFont(13);
    _contentLable.numberOfLines = 0;
    [self.contentView addSubview:_contentLable];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kFrameH(_nameLable)+kFrameH(_contentLable), SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    [self.contentView addSubview:lineLabel];
}

- (void)fillData:(DoctorModel *)model
{
    CGFloat theWidth = kWidth-40;
    
    CGSize nameSize = [Function sizeOfStr:model.doctorName andFont:GDBFont(18) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
    _nameLable.text = model.doctorName;
    _nameLable.frame = CGRectMake(20, 10, theWidth, nameSize.height);
    
    NSString *str = [NSString stringWithFormat:@"%@/%@",model.office,model.hospitalName];
    CGSize contentSize = [Function sizeOfStr:str andFont:GDBFont(13) andMaxSize:CGSizeMake(theWidth, CGFLOAT_MAX)];
    _contentLable.text = str;
    _contentLable.frame = CGRectMake(20, kFrameY(_nameLable)+kFrameH(_nameLable)+10, theWidth, contentSize.height);
    self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameY(_contentLable)+kFrameH(_contentLable)+10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
