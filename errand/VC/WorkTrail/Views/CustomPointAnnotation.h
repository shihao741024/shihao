//
//  CustomPointAnnotation.h
//  errand
//
//  Created by 高道斌 on 16/4/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>

@interface CustomPointAnnotation : MAPointAnnotation

//自定义的标注，包括图片和名字
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *avatar;

//只有图片，标注类型，起，停，终，自由打卡，客户拜访离，客户拜访抵,和位置分布时的数字
@property (nonatomic, copy) NSString *type;

@end
