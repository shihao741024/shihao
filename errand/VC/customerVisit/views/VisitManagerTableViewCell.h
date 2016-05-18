//
//  VisitManagerTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/31.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitManagerModel.h"
#import "ReportCountModel.h"
@interface VisitManagerTableViewCell : UITableViewCell

//@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UILabel *staffLbl;
@property (nonatomic, strong)UILabel *countLbl;
@property (nonatomic, strong)UILabel *lineLabel;
@property (nonatomic, strong)UILabel *currentLabel;
- (void)setVisitManagerModel:(VisitManagerModel*)model;
- (void)setReportCountArray:(NSArray *)countArray;
@end
