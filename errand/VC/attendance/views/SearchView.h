//
//  SearchView.h
//  errand
//
//  Created by gravel on 15/12/30.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDateView.h"
#import "MMAlertView.h"
#import "SelectStaffView.h"
#import "AttendanceBll.h"

@interface SearchView : UIView<MMDateViewDelegate,StaffViewDelegate>

//保存选中的models
@property (nonatomic, strong) NSMutableArray *selectModelArray;

@property (nonatomic, strong)UILabel *startLbl;
@property (nonatomic, strong)UILabel *endLbl;
@property (nonatomic, strong)UILabel *staffLbl;
@property(nonatomic,strong)SRRefreshView *slimeView;
- (instancetype)initWithFrame:(CGRect)frame andWithType:(int)type; //0 我的考勤记录 1 下属考勤记录
@property (nonatomic, copy)void (^recordBlock)(NSString *startDate ,NSString *endDate, NSString *staffStr,BOOL ISSearch);

@property (nonatomic, copy)void (^recordModelBlock)(NSString *startDate ,NSString *endDate, NSMutableArray *modelArray);

@end
