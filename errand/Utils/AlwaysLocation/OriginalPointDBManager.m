//
//  OriginalPointDBManager.m
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "OriginalPointDBManager.h"

@implementation OriginalPointDBManager

{
    FMDatabase *_fmdb;
}

+ (instancetype)shareManager
{
    static OriginalPointDBManager *manager = nil;
    @synchronized (manager)
    {
        if (!manager)
        {
            manager = [[OriginalPointDBManager alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fmdb = [FMDatabase databaseWithPath:LocationDBPath];
        [_fmdb open];
        [self createTableWithName:nil];
        [self dropTimeoutTable];
    }
    return self;
}

- (BOOL)createTableWithName:(NSString *)name;
{
    if ([_fmdb open]) {
        
        NSString *sqlstr = @"create table if not exists OriginalPoint (id integer primary key autoincrement, belongid integer, date varchar(32), latitude varchar(32), longitude varchar(32), time varchar(32))";
        
        if ([_fmdb executeUpdate:sqlstr]) {
            
            return YES;
        }else {
            NSLog(@"创建表失败");
            return NO;
        }
    }else {
        return NO;
    }
}

- (void)dropTimeoutTable
{
    NSString *sqlstr = @"delete from OriginalPoint where date != ?";
    NSString *todayDateStr = [[Function stringFromDate:[NSDate date]] substringToIndex:10];
    if (![_fmdb executeUpdate:sqlstr, todayDateStr]) {
        NSLog(@"删除失败");
    }
}

- (void)insertModel:(OriginalPointModel *)model
{
    NSString *sqlstr = @"insert into OriginalPoint (belongid, date, latitude, longitude, time) values(?, ?, ?, ?, ?)";
    if(![_fmdb executeUpdate:sqlstr, model.belongid, model.date, model.latitude, model.longitude, model.time])
    {
        NSLog(@"插入失败");
    }
}

- (void)insertModelWithArray:(NSMutableArray *)modelArray
{
    for (OriginalPointModel *model in modelArray) {
        [self insertModel:model];
    }
    
}

- (void)updatePathPoint:(OriginalPointModel *)model
{
    NSString *sqlstr = @"update OriginalPoint set latitude = ?, longitude = ? where id = ?";
    
    if(![_fmdb executeUpdate:sqlstr, model.latitude, model.longitude, model.ID])
    {
        NSLog(@"修改失败");
    }
}

- (NSMutableArray *)fetchAllModels
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *sqlstr = @"select * from OriginalPoint";
    FMResultSet *set = [_fmdb executeQuery:sqlstr];
    
    while ([set next]) {
        
        OriginalPointModel *model =[self getModelWithResultSet:set];
        [arr addObject:model];
    }
    return arr;
}

- (OriginalPointModel *)getModelWithResultSet:(FMResultSet *)set
{
    OriginalPointModel *model = [[OriginalPointModel alloc]init];
    model.ID = [NSNumber numberWithInt:[set intForColumn:@"id"]];
    model.belongid = [NSNumber numberWithInt:[set intForColumn:@"belongid"]];
    
    model.date = [set stringForColumn:@"date"];
    model.latitude = [set stringForColumn:@"latitude"];
    model.longitude = [set stringForColumn:@"longitude"];
    
    model.time = [set stringForColumn:@"time"];
    return model;
}

- (OriginalPointModel *)selectSomeResumes:(OriginalPointModel *)model
{
    NSString *str = @"select * from OriginalPoint where id = ?";
    FMResultSet *set = [_fmdb executeQuery:str, model.ID];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    while ([set next]) {
        
        OriginalPointModel *model =[self getModelWithResultSet:set];
        [arr addObject:model];
    }
    if (arr.count == 0) {
        return nil;
    }else {
        return arr[0];
    }
}

@end
