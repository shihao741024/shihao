//
//  BaseNoTabViewController.h
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailModel.h"
#import "DeclareDetailModel.h"
#import "MissionModel.h"
typedef enum{
    kContact = 0,
    kOrganization,
    kDoctorDetail
}ViewType;
@interface BaseNoTabViewController : UIViewController

/**
 *  传入参数，加载在传入的view视图上
 *
 *  @param bgView                  bgView description
 *  @param companyName             companyName description
 *  @param defaultStaffNameString  defaultStaffNameString description
 *  @param defaultDepartmentString defaultDepartmentString description
 *  @param defaultPositionString   defaultPositionString description
 *  @param defaultphoneString      defaultphoneString description
 *  @param staffNameString         staffNameString description
 *  @param departmentString        departmentString description
 *  @param positionString          positionString description
 *  @param phoneString             phoneString description
 *
 *  @return lable 用于员工详情页的 状态标签
 */
- (UILabel *)createFixedView:(UIView*)bgView andcompanyName:(NSString *)companyName
                         andDefaultStaffNameString:(NSString *)defaultStaffNameString
                         andDefaultDepartmentString:(NSString *)defaultDepartmentString
                         andDefaultPositionString:(NSString *)defaultPositionString
                         andDefaultphoneString:(NSString *)defaultphoneString
                         andStaffNameString:(NSString *)staffNameString
                         andDepartmentString:(NSString *)departmentString
                         andPositionString:(NSString *)positionString
                         andPhoneString:(NSString *)phoneString
                         andViewType:(ViewType)type;

/**
 *  传入参数，用于医生详情等页面的下部门视图的创建
 *
 *  @param string         string description
 *  @param selectedString selectedString description
 */
- (void)createBottomViewWithBottonView:(UIView*)bottomView
            andWithLeftNormalImageName:(NSString*)leftString
          andWithLeftSelectedImageName:(NSString*)leftSelectedString
           andWithRightNormalImageName:(NSString*)rightString
         andWithRightSelectedImageName:(NSString*)rightSelectedString;

/**
 *  用于任务详情页主视图的创建
 *
 *  @param bgView    bgView description
 *  @param type      type description
 *  @param taskModel taskModel description
 */
- (void)createTaskDetailMainViewWithBgView:(UIView*)bgView
                               andWithType:(int)type
                          andWithTaskModel:(TaskDetailModel*)taskModel;

- (void)createTaskDetailMainViewWithBgView:(UIView*)bgView
                               andWithType:(int)type
                       andWithDeclareModel:(DeclareDetailModel*)declareModel;


@end
