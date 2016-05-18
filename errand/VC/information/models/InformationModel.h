//
//  InformationModel.h
//  errand
//
//  Created by wjjxx on 16/3/22.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *createDate;
@property (nonatomic,strong)NSNumber *InformationID;
//*跳转 trip,id*/
@property (nonatomic,strong)NSString *data;
@property (nonatomic,assign)BOOL isEdit;
- (instancetype)initWithDic:(NSDictionary*)dic;

@end
