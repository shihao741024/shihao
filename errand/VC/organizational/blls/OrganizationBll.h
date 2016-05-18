//
//  OrganizationBll.h
//  errand
//
//  Created by gravel on 15/12/12.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
@interface OrganizationBll : RequestUtil

- (void)getFirstOrgnizationData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

- (void)getAboutSalesData:(void (^)(NSArray *arr))successArr salesId:(NSNumber*)salesId viewCtrl:(id)viewCtrl;

- (void)getSecondOrgnizationData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

//下级部门
- (void)getMyTreeData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;


@end
