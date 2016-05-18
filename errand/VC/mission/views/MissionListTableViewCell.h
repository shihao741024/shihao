//
//  MissionListTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"

@interface MissionListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblBack;

@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblFrom;
@property (strong, nonatomic) IBOutlet UIImageView *imgTravelType;
@property (strong, nonatomic) IBOutlet UILabel *lblTo;
@property (strong, nonatomic) IBOutlet UILabel *lblCycle;
@property (strong, nonatomic) IBOutlet UILabel *lblRemark;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;

@property(nonatomic,strong)MissionModel *model;

- (void)fillModel:(MissionModel *)model type:(int)type;

@property (strong, nonatomic) UILabel *waitLabel;

@end
