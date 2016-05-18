//
//  MissionEdittingViewController.h
//  errand
//
//  Created by gravel on 16/1/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"

@protocol MissionCommitDelegate <NSObject>

// 提交数据后回调该条数据，用于刷新UI
- (void)feedBackWithMissionModel:(MissionDetailModel *)model;

@end


@interface MissionEdittingViewController : UIViewController

@property(nonatomic)int type; //2 从消息页面跳过来

@property (nonatomic, strong)MissionDetailModel *missionModel;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, weak) id <MissionCommitDelegate> missionCommitDelegate;

@end
