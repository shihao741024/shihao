//
//  DoctorsViewController.h
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionModel.h"
#import "ContactModel.h"
#import "DoctorsModel.h"


@interface DoctorsViewController : UIViewController

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL phonebook;

@property(nonatomic,strong)ProductionModel *productionModel;
@property(nonatomic,strong)ContactModel *contactModel;

//退回顺序第几个vc
@property (nonatomic, assign) NSInteger popIndex;

- (void)searchDoctorInHospitalSelectAction:(void(^)(DoctorsModel *model))action;


@end
