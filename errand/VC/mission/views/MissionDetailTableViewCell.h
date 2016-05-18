//
//  MissionDetailTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionDetailTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel *orderLabel;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *stateLabel;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UILabel *lineLabel;
@property(nonatomic, strong)UILabel *reasonLabel;

- (void)setModel;

@end
