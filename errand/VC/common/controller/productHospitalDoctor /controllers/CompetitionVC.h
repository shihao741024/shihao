//
//  CompetitionVC.h
//  errand
//
//  Created by gravel on 16/2/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionModel.h"
@interface CompetitionVC : UIViewController

@property (nonatomic, copy)void (^feedBackProductionModelBlock)(ProductionModel *productionModel);

@end
