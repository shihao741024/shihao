//
//  HospitalTableViewCell.h
//  errand
//
//  Created by 高道斌 on 16/4/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface HospitalTableViewCell : UITableViewCell

- (void)selectButtonAction:(void(^)(HospitalTableViewCell *selectCell))action;

- (void)fillData:(ContactModel *)model hideSelectBtn:(BOOL)hideSelectBtn;

- (void)hideAllView:(BOOL)hide;

@end
