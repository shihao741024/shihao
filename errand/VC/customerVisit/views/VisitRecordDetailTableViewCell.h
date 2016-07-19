//
//  VisitRecordDetailTableViewCell.h
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitRecordDetailTableViewCell : UITableViewCell

- (void)fillData:(NSDictionary *)dic cornerStyle:(CornerStyle)cornerStyle;

@property (nonatomic, copy) void (^doctorNameLableClick)(NSNumber *doctorId);

@end
