//
//  MissionChildViewController.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"
@interface MissionChildViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MissionModel *model;
@property(nonatomic)int type;   //0我提交的  1 我处理的
@property (nonatomic, strong)NSArray *searchArray;

//编辑的所在行 和模型
@property (nonatomic ,strong)MissionModel *editModel;
@property (nonatomic ,strong)NSIndexPath *editIndexPath;


@end
