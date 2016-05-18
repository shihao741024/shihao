//
//  DeclareChildViewController.h
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "DeclareModel.h"

@interface DeclareChildViewController : BaseNoTabViewController

//@property (nonatomic, strong)NSArray *searchArray;//有没有搜索的数组

@property(nonatomic, assign)int type;

@property (nonatomic, strong)DeclareModel *model;

@property (nonatomic, strong)NSMutableDictionary *saveDic;


@end
