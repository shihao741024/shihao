//
//  OriginalPointDBManager.h
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginalPointModel.h"

@interface OriginalPointDBManager : NSObject

+ (instancetype)shareManager;

- (BOOL)createTableWithName:(NSString *)name;

- (void)dropTimeoutTable;

- (void)insertModel:(OriginalPointModel *)model;
- (void)insertModelWithArray:(NSMutableArray *)modelArray;
- (void)updatePathPoint:(OriginalPointModel *)model;

- (OriginalPointModel *)selectSomeResumes:(OriginalPointModel *)model;
- (NSMutableArray *)fetchAllModels;

@end
