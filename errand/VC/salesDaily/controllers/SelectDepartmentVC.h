//
//  SelectDepartmentVC.h
//  errand
//
//  Created by gravel on 16/3/1.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDepartmentVC : UIViewController

@property (nonatomic ,assign)int type; // 0 代表全部  1 代表下属  

@property (nonatomic,strong)NSMutableArray *departmentSelectArray;

@property (nonatomic,copy)void (^departmentSelectArrayBlock)(NSMutableArray *selectArray);


@property (nonatomic ,assign) BOOL selectCarryPeople; //选择携访人，单选，优先级高于type

@end
