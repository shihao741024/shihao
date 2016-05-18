//
//  SelectStaffViewController.h
//  errand
//
//  Created by gravel on 16/3/1.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"



@interface SelectStaffViewController : UIViewController

@property (nonatomic ,assign)int type; // 0 代表全部  1 代表下属 2 代表下属 并且不创建按部门选择 3 代表下属 并且不创建按部门选择 但只能单选

//返回员工和部门数组
@property (nonatomic,copy)void (^selectArrayBlock)(NSMutableArray *staffSelectArray,NSMutableArray *departmentArray);

//只返回员工数组
@property (nonatomic,copy)void (^selectstaffArrayBlock)(NSMutableArray *staffSelectArray);

//type == 3 只返回单个员工
@property (nonatomic,copy)void (^selectstaffBlock)(StaffModel *model);
@property (nonatomic ,copy)void (^feedBackStaffInfoBlock)(NSString *staffName,NSNumber *staffID);


@property (nonatomic, copy) void(^seletNodeStaffBlock)(NSString *staffName,NSNumber *staffID);

//搜索下属考勤，传过来的models
@property (nonatomic, strong) NSMutableArray *staffModelArray;
@property (nonatomic ,assign) BOOL subordinateLayout; //下属考勤进入时，调整布局
@property (nonatomic ,assign) BOOL selectCarryPeople; //选择携访人，单选，优先级高于type
@property (nonatomic, assign) BOOL searchVisitRecord; //查询拜访记录，选择拜访人
//查询拜访记录，传过来的dics
@property (nonatomic, strong) NSMutableArray *staffDicArray;

@property (nonatomic, assign) BOOL taskSearchPeople; //任务交办搜索发布人和交办人
@property (nonatomic, assign) BOOL reportSearchPublish; //销售日报搜索发布人

//staffDicArray是字典数组。key：name，ID
@property (nonatomic, copy) void(^searchVisitRecordStaffCB)(NSArray *staffDicArray);

@end
