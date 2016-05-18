//
//  DeclareDetailViewController.h
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "DeclareDetailModel.h"
@interface DeclareDetailViewController : BaseNoTabViewController

@property(nonatomic,assign)int type;   //0我分配的  1 我待办的

@property(nonatomic, strong)NSNumber *declareID;

@property (nonatomic,assign)int status;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy) void (^changeDeclareStatusBlock)(NSIndexPath *changeIndexPath , NSNumber *status, NSString *moneyStr);

@property (nonatomic, copy) void(^editFinishRefreshCB)();

@end
