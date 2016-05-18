//
//  FirstOrganizationalVC.h
//  errand
//
//  Created by gravel on 16/1/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"

@interface FirstOrganizationalVC : UIViewController

@property (nonatomic ,assign)int type;// 0 全部的数据 进入详情页 //1  选择部门里的人  2 全部的数据 但选择里面的人 回调


//@property (nonatomic ,assign) BOOL subordinateLayout; //下属考勤进入时，调整布局
@property (nonatomic ,assign) BOOL selectCarryPeople; //选择携访人，单选，优先级高于type
@property (nonatomic, assign) BOOL searchVisitRecord; //查询拜访记录，选择拜访人
@property (nonatomic, strong) NSMutableArray *selectDicArray;

//2 全部的数据 但选择里面的人 回调
@property (nonatomic ,copy)void (^feedBackStaffInfoBlock)(NSString *staffName,NSNumber *staffID);

//员工字典数组 key：name， ID
@property (nonatomic ,copy)void (^feedBackStaffArrayCB)(NSMutableArray *staffDicArray);




@end
