//
//  CountView.h
//  errand
//
//  Created by gravel on 16/2/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用来所有统计页面 上面的日期变换
 */

@protocol CountViewDelegate <NSObject>

- (void)buttonClickWithMonth:(NSString*)month;

@end

@interface CountView : UIView

@property (nonatomic, weak) id <CountViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(int)type; //0 销售统计 1 销售日报

@end
