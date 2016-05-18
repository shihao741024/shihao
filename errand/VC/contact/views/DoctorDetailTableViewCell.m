//
//  DoctorDetailTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DoctorDetailTableViewCell.h"

@implementation DoctorDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCell];
    }
    return self;
}
//@property (nonatomic, copy)NSString *visitName;
//@property (nonatomic, copy)NSString *notesString;
//@property (nonatomic, copy)NSString *sumString;
//@property (nonatomic, copy)NSString *timeString;
//@property (nonatomic, copy)NSString *stateString;
- (void)createCell{
    self.visitNameLabel = [self createLabel];
    self.notesLabel = [self createLabel];
    self.sumLabel = [self createLabel];
    self.timeLabel = [self createLabel];
    self.stateLabel = [self createLabel];
    
    //中间的黑线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 30, 1)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    [self.contentView addSubview:lineLabel];
    
    self.visitNameLabel.frame = CGRectMake(10, 10, 100, 40);
    self.sumLabel.frame = CGRectMake(10, 55, SCREEN_WIDTH, 40);
    
    [self.visitNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}
- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    return label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
