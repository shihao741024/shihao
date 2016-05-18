//
//  ProductionsViewController.h
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionModel.h"

@interface ProductionsViewController : UIViewController

@property (nonatomic, assign)int type; //0 直接返回  1 跳到医院界面 返回  2 跳到医院界面 然后调到医生界面 返回

@property (nonatomic, assign) NSInteger popIndex;

@property (nonatomic, assign)BOOL allProduct;

@property (nonatomic, copy)void (^feedBackProductionModelBlock)(ProductionModel *productionModel);

@end
