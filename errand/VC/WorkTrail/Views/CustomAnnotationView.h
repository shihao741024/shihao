//
//  CustomAnnotationView.h
//  errand
//
//  Created by 高道斌 on 16/4/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIImageView *portraitImageView;

@end
