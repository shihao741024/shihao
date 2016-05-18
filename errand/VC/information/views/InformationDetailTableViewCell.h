//
//  InformationDetailTableViewCell.h
//  errand
//
//  Created by wjjxx on 16/3/22.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"
@interface InformationDetailTableViewCell : UITableViewCell

/**
 *  <#Description#>
 */
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *selectedBtn;
//@property (nonatomic,strong)UILabel *
//@property (nonatomic,strong)UILabel *

- (void)setInformationModel:(InformationModel*)model isExpand:(BOOL)isExpand;

@property (nonatomic, copy)void (^informationSelectClick)();

@end
