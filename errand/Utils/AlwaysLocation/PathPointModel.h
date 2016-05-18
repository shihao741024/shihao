//
//  PathPointModel.h
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathPointModel : NSObject

//coordinate = "<null>";
//createDate = "<null>";
//id = 529;
//planDate = "2016-04-11 08:00";
//times = 1;

//@property (nonatomic, strong) NSDictionary *coordinate;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *belongid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *planDate;
@property (nonatomic, strong) NSNumber *times;
@property (nonatomic, strong) NSNumber *upload;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)getModelArrayWithDicArray:(NSMutableArray *)dicArray;



@end
