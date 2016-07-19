//
//  BaseDefine.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#ifndef BaseDefine_h
#define BaseDefine_h

#define SignTrackInfo @"SignTrackInfo"
#define LocationDBPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/LocationDB.db"]
#define LocationDBName @"LocationDB"
#define LocationTableExist @"LocationTableName"

#define pathKqOwnTop @"/api/v1/sale/kq/ownTop"
#define pathKqXs @"/api/v1/sale/kq/xs"
#define pathSalesXs @"/api/v1/sales/xs"

#define pathSaleMyMember @"/api/v1/sale/myMember"
#define pathSaleTaskCreate @"/api/v1/sale/task/create"
#define pathSaleVisitplansCreate @"/api/v1/sale/visitplans/create"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kFrameX(view) view.frame.origin.x
#define kFrameY(view) view.frame.origin.y

#define kFrameW(view) view.frame.size.width
#define kFrameH(view) view.frame.size.height

#define kImgWidth(image) image.size.width
#define kImgHeight(image) image.size.height

#define GDBFont(font) [UIFont systemFontOfSize:font]
#define GDBColorRGB(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

//添加拜访时选择完拜访客户
#define addVisitSelectCustomerNotification @"addVisitSelectCustomerNotification"
//登录成功通知
#define loginSuccessNotification @"loginSuccessNotification"

//退出登录通知
#define loginOutNotification @"loginOutNotification"

#define kGreenColor GDBColorRGB(0.40,0.79,0.11, 1)
#define kOrangeColor GDBColorRGB(1.00,0.60,0.37, 1)
#define kLineColor GDBColorRGB(0.88,0.88,0.88, 1)

#define kTableViewColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]
#define GDBUserID [Function userDefaultsObjForKey:@"userName"]
#define kAppName @"医路行"

#define LocationErrorAlertTag 21432132213
#define LocationAlertedFlag @"LocationAlertedFlag"

#define iOSVersion [[UIDevice currentDevice].systemVersion floatValue]

#define UMAnalyticsKey @"5696faf767e58e70c200194b"
#define UMPushKey @"5696faf767e58e70c200194b"
#define NoMoreData @"没有更多数据了"


//把self转化为 __weak __block的方式, 方便的在block中使用而不导致内存循环应用问题
//在宏中使用 \ 可以换行
#define WK(weakSelf) \
__block __weak __typeof(&*self)weakSelf = self;\


#define kTmpFolder [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define kMyCaches [kTmpFolder stringByAppendingPathComponent:@"Caches"]
#define UMPushAlertTag 8702295378

#define AppBulid [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* BaseDefine_h */
