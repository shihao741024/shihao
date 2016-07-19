//
//  ProcessView.m
//  errand
//
//  Created by gravel on 16/2/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ProcessView.h"

@implementation ProcessView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.orderLabel = [self createLabelWithFont:16 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
        self.nameLabel = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
        self.stateLabel = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter];
        self.dateLabel = [self createLabelWithFont:15 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentRight];
        self.lineLabel = [[UILabel alloc]init];
        self.lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [self addSubview:self.lineLabel];
        self.reasonLabel = [self createLabelWithFont:15 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentLeft];
         self.lineLabel2 = [[UILabel alloc]init];
        self.lineLabel2.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [self addSubview:self.lineLabel2];
    }
    return self;
}


- (void)setTaskDetailModelToView:(TaskDetailModel *)taskDetailModel{
    //    0 待接收 1 已接受 99已完成 3拒绝  -1 过期 -2取消
    self.nameLabel.text = taskDetailModel.receiverName;
    if ([taskDetailModel.stauts intValue]== 3 ) {
        self.stateLabel.text = @"拒绝任务";
        self.stateLabel.textColor = [UIColor colorWithRed:0.996 green:0.376 blue:0.365 alpha:1.000];
    }else{
        self.stateLabel.text = @"完成任务";
        self.stateLabel.textColor = [UIColor colorWithRed:0.459 green:0.796 blue:0.239 alpha:1.000];
    }
    CGSize size1 = [self sizeWithString:self.stateLabel.text font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.stateLabel.width = size1.width;
    self.reasonLabel.numberOfLines = 0;
    self.reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.reasonLabel.text = taskDetailModel.feedback;
    
    UIView *superView = self;
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
        make.width.equalTo(@20);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(0);
        make.top.equalTo(superView.mas_top).offset(0);
        make.right.equalTo(self.stateLabel.mas_left).offset(-5);
        make.height.equalTo(@20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateLabel.mas_left).offset(-10);
        make.top.equalTo(superView.mas_top).offset(0);
        make.height.equalTo(@20);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-10);
        make.top.equalTo(superView.mas_top).offset(0);
        make.height.equalTo(@20);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(0);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(5);
        make.right.equalTo(superView.mas_right).offset(0);
        make.height.equalTo(@1);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(0);
        make.top.equalTo(self.lineLabel.mas_bottom).offset(5);
        make.right.equalTo(superView.mas_right).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
    }];
    [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
        make.right.equalTo(superView.mas_right).offset(0);
        make.height.equalTo(@1);
        
    }];

}

//99终审 90审核并上报 0 待审核 -1审核不通过
- (void)setAuditInfosModelToView:(AuditInfosModel *)auditInfosModel andOrder:(int)order{
    self.orderLabel.text =[NSString stringWithFormat:@"%d",++order];
    self.nameLabel.text = auditInfosModel.name;
    if ([auditInfosModel.auditDate isEqualToString:@""]) {
        self.stateLabel.text = @"等待审批";
        self.stateLabel.textColor = COMMON_BLUE_COLOR;
        self.reasonLabel.text = auditInfosModel.message;
        
        UIView *superView = self;

        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(10);
            make.top.equalTo(superView.mas_top).offset(0);
//            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.mas_right).offset(0);
            make.top.equalTo(superView.mas_top).offset(0);
//            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.width.equalTo(@300);
             make.height.equalTo(@20);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.right.equalTo(superView.mas_right).offset(10);
            make.top.equalTo(superView.mas_top).offset(0);
//            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.width.equalTo(@100);
             make.height.equalTo(@20);
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(superView.mas_left).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@0);
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@0);

        }];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@0);

        }];
        [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@0);
            
        }];
        
        
    }else{
        self.dateLabel.text = [auditInfosModel.auditDate substringToIndex:10];
        //99终审 90审核并上报 0 待审核 -1审核不通过
        if ([auditInfosModel.status intValue] == -1) {
            self.stateLabel.text = @"审批驳回";
            self.stateLabel.textColor = [UIColor colorWithRed:0.996 green:0.376 blue:0.365 alpha:1.000];
        }else if ([auditInfosModel.status intValue] == 99){
            self.stateLabel.text = @"审批通过";
            self.stateLabel.textColor = [UIColor colorWithRed:0.459 green:0.796 blue:0.239 alpha:1.000];
        }else{
            self.stateLabel.text = @"上报审批";
            self.stateLabel.textColor = [UIColor colorWithRed:0.459 green:0.796 blue:0.239 alpha:1.000];
        }
        CGSize size1 = [self sizeWithString:self.stateLabel.text font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
        self.stateLabel.width = size1.width;
        
        CGSize size = [self sizeWithString:self.dateLabel.text font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
        self.dateLabel.width = size.width;
        self.reasonLabel.numberOfLines = 0;
        self.reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.reasonLabel.text = auditInfosModel.message;
        UIView *superView = self;
        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(10);
            make.top.equalTo(superView.mas_top).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.width.equalTo(@20);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.mas_right).offset(0);
            make.top.equalTo(superView.mas_top).offset(0);
            make.right.equalTo(self.stateLabel.mas_left).offset(-5);
            make.height.equalTo(@20);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dateLabel.mas_left).offset(-10);
            make.top.equalTo(superView.mas_top).offset(0);
            make.height.equalTo(@20);
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.mas_right).offset(-10);
            make.top.equalTo(superView.mas_top).offset(0);
            make.height.equalTo(@20);
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.mas_right).offset(0);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(5);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@1);
        }];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.mas_right).offset(0);
            make.top.equalTo(self.lineLabel.mas_bottom).offset(5);
            make.right.equalTo(superView.mas_right).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
        }];
        [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(0);
            make.bottom.equalTo(superView.mas_bottom).offset(0);
            make.right.equalTo(superView.mas_right).offset(0);
            make.height.equalTo(@1);
            
        }];

    }
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [self addSubview:label];
    return label;
}
#pragma mark - 计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
