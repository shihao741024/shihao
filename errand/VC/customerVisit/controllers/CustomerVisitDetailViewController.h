//
//  CustomerVisitDetailViewController.h
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "VisitDetailModel.h"

@interface CustomerVisitDetailViewController : BaseNoTabViewController


@property(nonatomic, strong)VisitDetailModel *visitDetailModel;

@property(nonatomic, strong)NSNumber *visitID;

@property(nonatomic, strong)NSString *status;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy) void (^changeVisitStatusBlock)(NSIndexPath *changeIndexPath , NSString *status);


//删除数据，返回前一个页面，刷新, 或者失访
@property (nonatomic, copy) void(^refreshBeforeDataCB)();


@end
