//
//  OriginalPointModel.h
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface OriginalPointModel : NSObject



@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *belongid;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *time;

- (instancetype)initWithLocation:(CLLocation *)location latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
+ (NSMutableArray *)getModelArrayWithDicArray:(NSMutableArray *)dicArray;

//(id integer primary key autoincrement,
// belongid integer,
// date varchar(32),
// latitude varchar(32),
// longitude varchar(32),
// time varchar(32)

@end
