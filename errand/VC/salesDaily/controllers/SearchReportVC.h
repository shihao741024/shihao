//
//  SearchReportVC.h
//  errand
//
//  Created by gravel on 16/3/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchReportVC : UIViewController

//用于保存搜索的条件
@property (nonatomic,copy)NSArray *searchArray;

@property (nonatomic, copy)void (^feedBackHallSearchDataBlock)(NSNumber *category,NSString *beginDate,NSString *endDate,NSString *content,NSArray *oids,NSArray *ids,NSString *publisher,NSString *kindStr, NSMutableArray *staffModelArray);

@end
