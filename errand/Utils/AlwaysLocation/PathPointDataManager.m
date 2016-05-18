//
//  PathPointDataManager.m
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PathPointDataManager.h"

@implementation PathPointDataManager
{
    FMDatabase *_fmdb;
}

+ (instancetype)shareManager
{
    static PathPointDataManager *manager = nil;
    @synchronized (manager)
    {
        if (!manager)
        {
            manager = [[PathPointDataManager alloc] init];
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
    }
    return self;
}

- (BOOL)tableExistsWithName:(NSString *)name
{
    NSString *tableName = [Function userDefaultsObjForKey:LocationTableExist];
    if (tableName) {
        if ([tableName isEqualToString:name]) {
            return YES;
        }else {
            [self dropTimeoutTable];
            return NO;
        }
    }else {
        [self dropTimeoutTable];
        return NO;
    }
}

- (BOOL)dropTimeoutTable
{
    if ([_fmdb open]) {
        NSString *sqlstr = @"drop table LocationTable";
        if ([_fmdb executeUpdate:sqlstr])
        {
            return YES;
        }else {
            NSLog(@"drop table error!");
            return NO;
        }
    }else {
        return NO;
    }
}

- (BOOL)createTableWithName:(NSString *)name;
{
    if ([_fmdb open]) {
        
        NSString *sqlstr = @"create table if not exists LocationTable (id integer, belongid integer, name varchar(1024), latitude varchar(32), longitude varchar(32), createDate varchar(32), planDate varchar(32), times integer, upload integer)";
        
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

- (void)insertModelWithArray:(NSMutableArray *)modelArray
{
    for (PathPointModel *model in modelArray) {
        NSString *sqlstr = @"insert into LocationTable (id, belongid, name, latitude, longitude, createDate, planDate, times, upload) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        if(![_fmdb executeUpdate:sqlstr, model.ID, model.belongid, model.name, model.latitude, model.longitude, model.createDate, model.planDate, model.times, model.upload])
        {
            NSLog(@"插入失败");
        }
    }
    
}

- (void)updatePathPoint:(PathPointModel *)model
{
    NSString *sqlstr = @"update LocationTable set name = ?, latitude = ?, longitude = ?, upload = ? where id = ?";
    
    if(![_fmdb executeUpdate:sqlstr, model.name, model.latitude, model.longitude, model.upload, model.ID])
    {
        NSLog(@"修改失败");
    }
}

- (NSMutableArray *)fetchAllModels
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *sqlstr = @"select * from LocationTable";
    FMResultSet *set = [_fmdb executeQuery:sqlstr];
    
    while ([set next]) {
        
        PathPointModel *model =[self getModelWithResultSet:set];
        [arr addObject:model];
    }
    return arr;
}

- (NSMutableArray *)fetchAllModelsPlanDate
{
    NSMutableArray *modelArray = [[PathPointDataManager shareManager] fetchAllModels];
    NSMutableArray *planDate = [NSMutableArray array];
    for (PathPointModel *model in modelArray) {
        [planDate addObject:model.planDate];
    }
    return planDate;
}

- (PathPointModel *)getModelWithResultSet:(FMResultSet *)set
{
    PathPointModel *model = [[PathPointModel alloc]init];
    model.ID = [NSNumber numberWithInt:[set intForColumn:@"id"]];
    model.belongid = [NSNumber numberWithInt:[set intForColumn:@"belongid"]];
    model.name = [set stringForColumn:@"name"];
    
    model.latitude = [set stringForColumn:@"latitude"];
    model.longitude = [set stringForColumn:@"longitude"];
    
    model.createDate = [set stringForColumn:@"createDate"];
    model.planDate = [set stringForColumn:@"planDate"];
    
    model.times = [NSNumber numberWithInt:[set intForColumn:@"times"]];
    model.upload = [NSNumber numberWithInt:[set intForColumn:@"upload"]];
    return model;
}

- (PathPointModel *)selectPathPointModel:(PathPointModel *)model
{
    NSString *sqlstr = @"select * from LocationTable where id = ?";
    FMResultSet *set = [_fmdb executeQuery:sqlstr, model.ID];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    while ([set next]) {
        
        PathPointModel *model =[self getModelWithResultSet:set];
        [arr addObject:model];
    }
    if (arr.count == 0) {
        return nil;
    }else {
        return arr[0];
    }
}

- (PathPointModel *)selectPathPointTimes:(NSNumber *)times
{
    NSString *str = @"select * from LocationTable where times = ?";
    FMResultSet *set = [_fmdb executeQuery:str, [times intValue]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    while ([set next]) {
        
        PathPointModel *model =[self getModelWithResultSet:set];
        [arr addObject:model];
    }
    if (arr.count == 0) {
        return nil;
    }else {
        return arr[0];
    }
}

/*

- (void)deleteResume:(ResumeStatusModel *)model
{
    NSString *str = @"delete from resumes where wjid = ?";
    if (![_fmdb executeUpdate:str, model.wjid]) {
        NSLog(@"删除失败");
    }
}


- (NSMutableArray *)selectSomeResumesArray:(NSArray *)modelArray
{
    NSMutableArray *whyArray = [[NSMutableArray alloc] init];
    NSMutableArray *wjidArray = [[NSMutableArray alloc] init];
    for (ResumeStatusModel *model in modelArray) {
        [wjidArray addObject:model.wjid];
        [whyArray addObject:@"?"];
    }
    
    NSString *str = [NSString stringWithFormat:@"select * from resumes where wjid in (%@)",[whyArray componentsJoinedByString:@","]];
    FMResultSet *set = [_fmdb executeQuery:str withArgumentsInArray:wjidArray];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    while ([set next]) {
        ResumeStatusModel *model = [[ResumeStatusModel alloc]init];
        
        model.wjid = [set stringForColumn:@"wjid"];
        model.status = [set stringForColumn:@"status"];
        
        model.updateTime = [set stringForColumn:@"updateTime"];
        model.collection = [set stringForColumn:@"collection"];
        
        [arr addObject:model];
    }
    
    return arr;
}

- (BOOL)isResumeExists:(ResumeStatusModel *)model
{
    NSString *str = @"select * from resumes where wjid = ?";
    FMResultSet *set = [_fmdb executeQuery:str, model.wjid];
    return [set next];
}
 
 */


/*
 事务:从开启事务开始,所有的操作都是暂时的
 如果后面是回滚,之前的所有的这些操作都会被取消
 如果是提交,所有的操作都会被提交到数据库
 */


- (void)beginTransaction
{
    [_fmdb beginTransaction];
}

- (void)commit
{
    [_fmdb commit];
}

- (void)rollBack
{
    if ([_fmdb inTransaction]) {
        [_fmdb rollback];
    }
}

@end
