//
//  ErrandItemBll.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ErrandItemBll.h"
#import "SDHomeGridItemModel.h"

@implementation ErrandItemBll
+(NSArray*)getAllItem{
    NSBundle *bundle=[NSBundle mainBundle];
   
    NSString *path=[bundle pathForResource:@"allItem" ofType:@"plist"];
   
    NSDictionary *dictionary=[[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *array=[dictionary allKeys];
    NSMutableArray *mutArry=[NSMutableArray new];
    for(id key in dictionary)
    {
        NSArray *arrays=[dictionary objectForKey:key];
        SDHomeGridItemModel *model=[SDHomeGridItemModel new];
        model.ischecked=NO;
        model.itemId=[arrays objectAtIndex:0];
        model.imageResString=[arrays objectAtIndex:1];
        model.toClassSeg=[arrays objectAtIndex:3];
        NSString *str=[arrays objectAtIndex:2];
        model.title=NSLocalizedString(str,str);
//        NSLog(@"%@%@%@%@",model.itemId,model.toClassSeg,model.imageResString,model.title);
        [mutArry addObject:model];
    }
     SDHomeGridItemModel *tempModel=[SDHomeGridItemModel new];
    for (int i = 0; i < mutArry.count; i++) {
        for (int k = 0; k < mutArry.count-1; k ++) {
            if ([[mutArry[k] itemId] intValue] > [[mutArry[k+1] itemId] intValue]) {
                tempModel = mutArry[k];
                mutArry[k] = mutArry[k+1];
                mutArry[k+1] = tempModel;
            }
        }
    }
    return [mutArry copy];
}

/**
 *  根据id字符串获取我的项目
 */
+(NSArray*)getMyItem:(NSString*)idStr allItem:(NSArray*)allItem{
     NSMutableArray *myarr=[NSMutableArray new];
    if(!allItem||allItem.count==0||idStr.length==0)
        return [myarr copy];
    NSArray *arrs=[idStr componentsSeparatedByString:@","];
    
    [arrs enumerateObjectsUsingBlock:^(NSString *id, NSUInteger idx1, BOOL *stop1)  {
      [allItem enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model, NSUInteger idx, BOOL *stop)  {
            if([model.itemId isEqualToString:id])
            {
                [myarr addObject:model];
                stop=YES;
            }
        }];
        if(arrs.count==myarr.count)
            stop1=YES;
    }];
    return [myarr copy];
    
}

/**
 *  根据id字符串获取我的项目
 */
+(NSArray*)getMyItem:(NSString*)idStr{
    NSArray *arr=[self getAllItem];
    return [self getMyItem:idStr allItem:arr];
}
@end
