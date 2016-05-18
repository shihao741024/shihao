//
//  PathPointDataManager.h
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathPointModel.h"

@interface PathPointDataManager : NSObject


+ (instancetype)shareManager;

- (BOOL)tableExistsWithName:(NSString *)name;
- (BOOL)createTableWithName:(NSString *)name;
- (BOOL)dropTimeoutTable;

- (void)insertModelWithArray:(NSMutableArray *)modelArray;
- (void)updatePathPoint:(PathPointModel *)model;

- (PathPointModel *)selectPathPointTimes:(NSNumber *)times;
- (PathPointModel *)selectPathPointModel:(PathPointModel *)model;
- (NSMutableArray *)fetchAllModels;
- (NSMutableArray *)fetchAllModelsPlanDate;

//- (void)deleteResume:(ResumeStatusModel *)model;


//- (NSMutableArray *)selectSomeResumesArray:(NSArray *)modelArray;

//- (BOOL)isResumeExists:(ResumeStatusModel *)model;

//开启事务
- (void)beginTransaction;

//提交
- (void)commit;

//回滚
- (void)rollBack;

@end
