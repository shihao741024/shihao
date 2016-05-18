//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
@protocol MMDateViewDelegate;
@interface MMDateView : MMPopupView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) id<MMDateViewDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *customIndexPath;
//额外加的标识，销售统计查询，上报开始时间(start)，或者结束时间(end)
@property (nonatomic, copy) NSString *searchTime;

@property (nonatomic, strong) UILabel *centerLabel;

@end

@protocol MMDateViewDelegate<NSObject>
@optional
-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker;
@end
