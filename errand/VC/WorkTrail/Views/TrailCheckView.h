//
//  TrailCheckView.h
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailCheckView : UIView

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *bottomButton;

//type 0 自由打卡， 1客户拜访
- (void)buttonClickAction:(void(^)(NSInteger type, BOOL selected))action;

@end
