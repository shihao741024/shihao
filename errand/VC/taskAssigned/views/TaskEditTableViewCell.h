//
//  TaskEditTableViewCell.h
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJJLabel.h"

@interface TaskEditTableViewCell : UITableViewCell

@property (nonatomic, strong) WJJLabel *nameLabel;
@property (nonatomic, strong) WJJLabel *detailLabel;

@end
