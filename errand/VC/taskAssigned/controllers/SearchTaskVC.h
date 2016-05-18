//
//  SearchTaskVC.h
//  errand
//
//  Created by gravel on 16/3/15.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTaskVC : UIViewController


@property (nonatomic, strong)NSArray *searchArray;

@property (nonatomic, assign)int type;
@property (nonatomic, copy)void (^feedBackTaskSearchDataBlock)(NSNumber *category,NSString *beginDate,NSString *endDate,NSString *content,NSString *title,NSNumber *to,NSString *staffName,NSString *kindStr);

@end
