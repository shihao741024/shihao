//
//  JurisdictionVC.h
//  errand
//
//  Created by gravel on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JurisdictionVC : UIViewController

@property (nonatomic, copy)NSString *jurisdictionStr;

@property(nonatomic, copy) void (^jurisdictionClickBlock)(NSString *str);

@end
