//
//  DoctorDynamicView.h
//  errand
//
//  Created by 高道斌 on 16/5/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorDynamicView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *footerButton;


@property (nonatomic, strong) NSMutableArray *dicArray;

- (void)reloadData:(id)responseObject pageIndex:(NSInteger)pageIndex;

//- (void)changeSelfHeight:(CGFloat)height;


@property (nonatomic, copy) void(^changeSelfHeightCB)(CGFloat height);

@property (nonatomic, copy) void(^buttonClickCB)(UIButton *button);

@end
