//
//  MissionListTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionListTableViewCell.h"

@implementation MissionListTableViewCell

- (void)awakeFromNib {
    self.backgroundColor=COMMON_BACK_COLOR;
    _lblBack.layer.cornerRadius=8.0;
    _lblBack.layer.masksToBounds=YES;
    // Initialization code
    
    _waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameW(_lblBack)-20-50, 15, 50, 20)];
    _waitLabel.textColor = [UIColor redColor];
    _waitLabel.text = @"wait";
    _waitLabel.font = GDBFont(15);
    _waitLabel.hidden = YES;
    _waitLabel.textAlignment = NSTextAlignmentRight;
    [_lblBack addSubview:_waitLabel];
}
-(void)setModel:(MissionModel *)model{
    _model=model;
    _imgStatus.image = [UIImage imageNamed:[NSString stringWithFormat:@"status%d",model.status]];
    _lblFrom.text=model.from;
    _lblTo.text=model.to;
    _lblCycle.text= model.startDate;
    _lblEndDate.text = model.endDate;

    _lblRemark.text=model.remark;
    _imgTravelType.image=[UIImage imageNamed:[NSString stringWithFormat:@"travelType%d",model.travelType]];
}

- (void)fillModel:(MissionModel *)model type:(int)type
{
    _model=model;
    _imgStatus.image = [UIImage imageNamed:[NSString stringWithFormat:@"status%d",model.status]];
    _lblFrom.text=model.from;
    _lblTo.text=model.to;
    _lblCycle.text= model.startDate;
    _lblEndDate.text = model.endDate;
    
    _lblRemark.text=model.remark;
    _imgTravelType.image=[UIImage imageNamed:[NSString stringWithFormat:@"travelType%d",model.travelType]];
    
    if (type == 1) {
        if (model.status == 90) {
            if ([model.organizationID isEqual:[Function userDefaultsObjForKey:@"organizationID"]]) {
                _waitLabel.hidden = NO;
            }else {
                _waitLabel.hidden = YES;
            }
        }else {
            _waitLabel.hidden = YES;
        }
    }else {
        _waitLabel.hidden = YES;
    }
    
    _waitLabel.frame = CGRectMake(kWidth-13-20-50, 15, 50, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
