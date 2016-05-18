//
//  ErrandItemBll.h
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrandItemBll : NSObject

/**
 *  获取全部项目
 */
+(NSArray*)getAllItem;

/**
 *  根据id字符串获取我的项目
 */
+(NSArray*)getMyItem:(NSString*)idStr allItem:(NSArray*)allItem;

/**
 *  根据id字符串获取我的项目
 */
+(NSArray*)getMyItem:(NSString*)idStr;
@end
