//
//  TaskDetailViewController.h
//  errand
//
//  Created by gravel on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "TaskDetailModel.h"
@interface TaskDetailViewController : BaseNoTabViewController

@property(nonatomic,assign)int type;   //0我分配的  1 我待办的

@property(nonatomic, retain)TaskDetailModel *taskModel;

@property (nonatomic,strong)NSNumber *taskID;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy) void (^changeStatusBlock)(NSIndexPath *changeIndexPath , NSString *status );

@end
