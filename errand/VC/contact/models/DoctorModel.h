//
//  DoctorModel.h
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorModel : NSObject

//基本属性
@property(nonatomic,copy)NSString *hospitalName;
@property(nonatomic,copy)NSString *doctorName;
@property(nonatomic,copy)NSString *departmentString;
@property(nonatomic,copy)NSString *positionString;
@property(nonatomic,copy)NSString *phoneString;

//动态及费用
@property (nonatomic, copy)NSString *visitName;
@property (nonatomic, copy)NSString *notesString;
@property (nonatomic, copy)NSString *sumString;
@property (nonatomic, copy)NSString *timeString;
@property (nonatomic, copy)NSString *stateString;

@end
