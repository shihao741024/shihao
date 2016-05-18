//
//  TaskTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskTableViewCell.h"
@implementation TaskTableViewCell{
    UIView *_bgView ;
}

- (void)awakeFromNib {
    // Initialization code
 
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:@"cell"]) {
      
         [self createCell];
    }
    return self;
}
- (void)createCell{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    UIView *pointView = [[UIView alloc]init];
    pointView.size = CGSizeMake(5, 5);
    pointView.layer.cornerRadius = 2.5;
    pointView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:pointView];
    pointView.hidden = YES;
    
    UIView *pointView2  = [[UIView alloc]init];
    pointView2.size = CGSizeMake(5, 5);
    pointView2.layer.cornerRadius = 2.5;
    pointView2.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:pointView2];
    pointView2.hidden = YES;
    
   

    self.statusImgView = [[UIImageView alloc] init];
    [_bgView addSubview:self.statusImgView];
    
    self.taskNameLabel = [self createLabelWithFont:14 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.startDate = [self createLabelWithFont:14 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentRight];
    self.phoneNumber = [self createLabelWithFont:20 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
//    self.receiveName = [self createLabelWithFont:21 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.endDate = [self createLabelWithFont:14 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.remarkLabel = [self createLabelWithFont:14 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    
    self.visitTypeLabel = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentRight];
    self.visitTypeLabel.font = [UIFont italicSystemFontOfSize:15];
    self.visitTypeLabel.hidden = YES;
    
    
    UIView *superView = self;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
    }];
    
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startDate.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(@20);
    }];
    
    [self.startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.right.equalTo(_bgView.mas_right).offset(-55);
        make.height.equalTo(@25);
    }];
    
//    [self.receiveName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(5);
//        make.left.equalTo(self.phoneNumber.mas_right).offset(3);
//        make.width.equalTo(@100);
//        make.height.equalTo(@25);
//
//    }];
    
    [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(@20);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endDate.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(5+8);
        make.left.equalTo(_bgView.mas_left).offset(20);
        make.width.equalTo(@5);
        make.height.equalTo(@5);
    }];
    
    [pointView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endDate.mas_bottom).offset(5+8);
        make.left.equalTo(_bgView.mas_left).offset(20);
        make.width.equalTo(@5);
        make.height.equalTo(@5);
    }];
    self.stateBtn = [[UIButton alloc] init];
   
    [_bgView addSubview:self.stateBtn];
 
    _waitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _waitLabel.textColor = [UIColor redColor];
    _waitLabel.text = @"wait";
    _waitLabel.font = GDBFont(15);
    _waitLabel.hidden = YES;
    _waitLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_waitLabel];
    
    [_waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(40);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
}

-(void)setModel:(TaskModel *)model category:(int)category{
    
    self.statusImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"taskStatus%@",model.stauts]];
     [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
        
    }];
    
    if ([model.priority isEqualToString:@"0"]) {
        self.startDate.text = @"普通";
        self.startDate.textColor = [UIColor colorWithRed:0.459 green:0.796 blue:0.239 alpha:1.000];
    }else{
        self.startDate.text = @"紧急";
        
        self.startDate.textColor = [UIColor colorWithRed:0.996 green:0.376 blue:0.365 alpha:1.000];
    }
    self.taskNameLabel.text = model.taskName;
    if (category == 0) {
        
        self.phoneNumber.text = model.receiverName;
        
    }else{
        
        self.phoneNumber.text = model.releaser;

    }
    
    self.endDate.text = model.planCompleteDate;
    self.remarkLabel.text = model.contentStr;
    
    [self.stateBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [self.stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(0);
        make.right.equalTo(_bgView.mas_right).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        
    }];

    
    
//       NSLog(@"%@",model.stateString);
    
}
- (void)stateBtnClick:(UIButton *)btn {
//    NSLog(@"111");
    self.callPhoneBlock();
}
-(void)setDeclareModel:(DeclareModel *)model type:(int)type{
    
   self.statusImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"status%@",model.currentStatus]];
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
        
    }];
    
    self.startDate.text = model.createDate;
    self.taskNameLabel.text = model.declareName;
    self.phoneNumber.text = [NSString stringWithFormat:@"%.2f元", [model.moneyString floatValue]];
    self.phoneNumber.textColor = COMMON_BLUE_COLOR;
    self.receiveName.text = @"";
    self.endDate.text = model.wayString;
    self.remarkLabel.text = model.remarkString;
    self.phoneImageLabel.text = @"";
    
    if (type == 1) {
        if ([model.currentStatus isEqual:@90]) {
            if ([model.organizationID isEqual:[Function userDefaultsObjForKey:@"organizationID"]]) {
                _waitLabel.hidden = NO;
            }else {
                _waitLabel.hidden = YES;
            }
        }else {
            _waitLabel.hidden = YES;
        }
    }else {
        _waitLabel.hidden = YES;
    }
}
-(void)setSalesStatisticsModel:(SalesStatisticsModel *)model{
//    self.stateLabel.textColor = [UIColor grayColor];
//    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    self.statusImgView.backgroundColor = [UIColor whiteColor];
//    self.stateLabel.text = model.dateString;
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@16);
        
    }];
   
    self.startDate.text = @"";
    self.taskNameLabel.text = model.pillName;
    self.phoneNumber.text = model.amountString;
    self.receiveName.text = @"";
    self.endDate.text = model.hospitalName;
    self.remarkLabel.text = model.buyerString;
    self.phoneImageLabel.text = @"";
    
}
-(void)setCustomerVisitModel:(CustomerVisitModel *)model{
    self.statusImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"visitStatus%@",model.stateString]];
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
        
    }];
    self.startDate.text = model.startDate;
    self.taskNameLabel.text = model.hospitalName;
    
    self.phoneNumber.text = model.doctorName;
    self.receiveName.text = @"";
    self.endDate.text = model.endDate;
    self.remarkLabel.text = model.remarkString;
    self.phoneImageLabel.text = @"";
    
    [self.stateBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [self.stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(0);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        
    }];
    self.stateBtn.hidden = YES;

    [self.visitTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(0);
        make.right.equalTo(_bgView.mas_right).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
        
    }];
    
    self.visitTypeLabel.hidden = NO;
    if ([model.category isEqual:@0]) {
        self.visitTypeLabel.textColor = kGreenColor;
        self.visitTypeLabel.text = @"计划拜访";
    }else {
        self.visitTypeLabel.text = @"临时拜访";
        self.visitTypeLabel.textColor = kOrangeColor;
    }
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [_bgView addSubview:label];
    return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
