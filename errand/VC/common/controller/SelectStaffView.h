//
//  StaffView.h
//  errand
//
//  Created by gravel on 16/2/19.
//  Copyright © 2016年 weishi. All rights reserved.
//
/**
 *  用来选择下属员工
 *
 *  @return return value description
 */
#import <UIKit/UIKit.h>
#import "AttendanceBll.h"

@protocol StaffViewDelegate <NSObject>

- (void)selectStaffWithName:(NSString*)name andTelephone:(NSString*)telephone andID:(NSNumber*)id;

- (void)selectStaffWithInfo:(StaffInfoModel *)model;


@end

@interface SelectStaffView : UIView<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@property (nonatomic, weak) id <StaffViewDelegate>delegate;

@end

