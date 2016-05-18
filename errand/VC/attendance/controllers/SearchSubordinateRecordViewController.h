//
//  SearchSubordinateRecordViewController.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SubordinateRecordViewController.h"
#import "StaffInfoModel.h"

@interface SearchSubordinateRecordViewController : SubordinateRecordViewController

@property (nonatomic, copy) NSString *passStartDate;
@property (nonatomic, copy) NSString *passEndDate;
@property (nonatomic, strong) NSMutableArray *modelArray;


@end
