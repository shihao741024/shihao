//
//  MassageAndPhoneView.h
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MassageAndPhoneView : UIView

//type == 0 phone , == 1 msg
- (void)msgOrPhoneClickAction:(void(^)(NSInteger type))action;

@end
