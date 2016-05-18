//
//  TreeStaffModel.h
//  errand
//
//  Created by gravel on 16/1/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeStaffModel : NSObject

@property (nonatomic, strong)NSString *name;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
