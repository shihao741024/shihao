//
//  SubordinateDateSelectView.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubordinateDateSelectView : UIView

@property (nonatomic, copy) void(^seletedDateCB)(NSString *position);
- (void)seletedDateAction:(void(^)(NSString *position))action;

- (void)reloadTitle:(NSString *)title;

@end
