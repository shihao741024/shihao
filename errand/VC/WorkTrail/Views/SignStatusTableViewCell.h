//
//  SignStatusTableViewCell.h
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignStatusTableViewCell : UITableViewCell

- (void)fillData:(NSDictionary *)dic;

- (void)hideAllView:(BOOL)hide;

@end
