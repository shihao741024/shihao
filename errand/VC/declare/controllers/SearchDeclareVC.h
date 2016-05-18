//
//  SearchDeclareVC.h
//  errand
//
//  Created by wjjxx on 16/3/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDeclareVC : UIViewController

//0 是搜索我提交的，1是我审批的
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)NSArray *searchArray;

@property (nonatomic, copy)void (^feedBackDeclareSearchDataBlock)(NSString *title,NSString *customerName,NSString *useWay,NSString *aim,NSString *remark,NSString *statusStr,NSNumber* status,NSNumber *productID,NSNumber *hospitalID,NSNumber *doctorID,NSString *productStr, NSMutableDictionary *saveDic);

@property (nonatomic, strong) NSMutableDictionary *saveDic;


@end
