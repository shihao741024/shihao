//
//  TaskAssignedViewChildViewController.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface TaskAssignedChildViewController : UIViewController

@property(nonatomic)int type;   //0我提交的  1 我处理的

@property (nonatomic, strong)TaskModel *model;

@property (nonatomic, strong)NSArray *searchArray;

@property (nonatomic, strong)NSArray<TaskModel *> *models;


- (void)searchAction;


@end
