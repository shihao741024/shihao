//
//  SearchMissionVC.h
//  errand
//
//  Created by wjjxx on 16/3/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMissionVC : UIViewController


@property (nonatomic, strong)NSArray *searchArray;

@property (nonatomic, assign)int type;
@property (nonatomic, copy)void (^feedBackMissionSearchDataBlock)(NSString *start,NSString *dest,NSString *content,NSString *startDate,NSString *endDate,NSNumber * traveType,NSNumber* status, NSString *traveTypeStr,NSString *statusStr);

@end
