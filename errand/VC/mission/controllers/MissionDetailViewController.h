//
//  MissionDetailViewController.h
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "MissionDetailModel.h"
#import "MissionModel.h"
@interface MissionDetailViewController : BaseNoTabViewController

@property(nonatomic)int type; //2 从消息页面跳过来

@property (nonatomic,strong)NSNumber *missionID;

@property (nonatomic,strong)NSIndexPath *indexPath;

//回调 改变状态
@property (nonatomic,copy) void (^changeMissionStatusBlock)(NSIndexPath *changeIndexPath , int status, MissionModel *missionModel);
//删除
@property (nonatomic,copy) void (^deleteMissionDataBlock)(NSIndexPath *deleteIndexPath);
@end
