//
//  TaskTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DeclareModel.h"
#import "SalesStatisticsModel.h"
#import "CustomerVisitModel.h"
@interface TaskTableViewCell : UITableViewCell

@property(nonatomic, retain)UIImageView *statusImgView;
@property(nonatomic, retain)UILabel *startDate;
@property(nonatomic, retain)UILabel *taskNameLabel;
@property(nonatomic, retain)UILabel *phoneNumber;
@property(nonatomic, retain)UILabel *receiveName;
@property(nonatomic, retain)UILabel *endDate;
@property(nonatomic, retain)UILabel *remarkLabel;
@property(nonatomic, retain)UILabel *phoneImageLabel;
@property(nonatomic, copy)NSString *imageName;
@property(nonatomic, retain)UIButton *stateBtn;

@property(nonatomic, retain)UILabel *visitTypeLabel;
@property(nonatomic, strong)UILabel *waitLabel;

@property(nonatomic,copy) void (^callPhoneBlock)();

-(void)setModel:(TaskModel *)model category:(int)category;

-(void)setDeclareModel:(DeclareModel *)model type:(int)type;
//-(void)setSalesStatisticsModel:(SalesStatisticsModel *)model;
-(void)setCustomerVisitModel:(CustomerVisitModel *)model;
@end
