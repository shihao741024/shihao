//
//  PeopleLastLocationTableViewCell.h
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleLastLocationTableViewCell : UITableViewCell

- (void)fillData:(NSDictionary *)dic status:(NSInteger)status;

- (void)hideAllView:(BOOL)hide;

@end
