//
//  ProcessView.h
//  errand
//
//  Created by gravel on 16/2/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskDetailModel.h"
#import "AuditInfosModel.h"
@interface ProcessView : UIView
@property(nonatomic, strong)UILabel *orderLabel;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *stateLabel;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UILabel *lineLabel;
@property(nonatomic, strong)UILabel *reasonLabel;
@property(nonatomic, strong)UILabel *lineLabel2;


//任务交办
- (void)setTaskDetailModelToView:(TaskDetailModel *)taskDetailModel;

//出差管理
- (void)setAuditInfosModelToView:(AuditInfosModel *)auditInfosModel andOrder:(int)order;


@end
