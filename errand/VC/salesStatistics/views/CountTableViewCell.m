//
//  CountTableViewCell.m
//  errand
//
//  Created by gravel on 16/2/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CountTableViewCell.h"

@implementation CountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)createCell{
    
    float pillWidth = (SCREEN_WIDTH - 10)/3;
    
    UILabel *pillLabel = [self createSameLabelWithFrame:CGRectMake(0, 0, pillWidth, self.height)];
    _pillLabel = pillLabel;
    _pillLabel.numberOfLines = 0;
    [self addSubview:_pillLabel];
    
    UILabel *hospitalLabel = [self createSameLabelWithFrame:CGRectMake(pillWidth, 0, pillWidth, self.height)];
    _hospitalLabel = hospitalLabel;
    _hospitalLabel.numberOfLines = 0;
    [self addSubview:_hospitalLabel];
    
    UILabel *countLabel = [self createSameLabelWithFrame:CGRectMake(pillWidth*2, 0, pillWidth, self.height)];
    _countLabel = countLabel;
    [self addSubview:_countLabel];
    
    
}

-(void)setStatisticsCountModel:(StatisticsCountModel *)model andColor:(UIColor *)color type:(int)type{
    //0 代表偶数行 1代表奇数行
    self.backgroundColor = color;
    _pillLabel.text = [NSString stringWithFormat:@"%@\n%@", model.pillName, model.specification];
    _hospitalLabel.text = model.hospitalName;
    _countLabel.text = [NSString stringWithFormat:@"%@",model.count];
    
    
    if (type == 0) {
        _hospitalLabel.text = model.hospitalName;
    }else {
        _hospitalLabel.text = [NSString stringWithFormat:@"%@\n%@", model.doctorName, model.secondHosName];
    }
    float pillWidth = (SCREEN_WIDTH - 10)/3;
    
    CGSize size = [Function sizeOfStr:_hospitalLabel.text andFont:GDBFont(17) andMaxSize:CGSizeMake(kFrameW(_hospitalLabel), CGFLOAT_MAX)];
    
    if (size.height < 44) {
        self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), 44);
    }else {
        self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), size.height);
    }
    
    _pillLabel.frame = CGRectMake(0, 0, pillWidth, self.height);
    _hospitalLabel.frame = CGRectMake(pillWidth, 0, pillWidth, self.height);
    _countLabel.frame = CGRectMake(pillWidth*2, 0, pillWidth, self.height);
}

- (UILabel *)createSameLabelWithFrame:(CGRect)frame{
    UILabel *sameLabel = [[UILabel alloc]initWithFrame:frame];
    sameLabel.layer.borderColor = [UIColor colorWithWhite:0.906 alpha:1.000].CGColor;
    sameLabel.layer.borderWidth = 0.5;
    sameLabel.textAlignment = NSTextAlignmentCenter;
    return sameLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
