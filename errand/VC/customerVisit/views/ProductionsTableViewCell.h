//
//  ProductionsTableViewCell.h
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionModel.h"

@interface ProductionsTableViewCell : UITableViewCell

- (void)fillData:(ProductionModel *)model;

- (void)hideAllView:(BOOL)hide;

@end
