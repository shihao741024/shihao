//
//  VisitRecordSearchViewController.h
//  errand
//
//  Created by pro on 16/4/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VisitRecordViewController.h"
#import "DoctorsModel.h"

@class ProductionModel, ContactModel;

@interface SearchResultViewController : VisitRecordViewController

@property (nonatomic, strong) NSArray *staffDicArray;
@property (nonatomic, strong) ProductionModel *productmodel;
@property (nonatomic, strong) ContactModel *contactModel;

@property (nonatomic, strong) DoctorsModel *doctorsModel;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *typeStr;

@end


@interface VisitRecordSearchViewController : UIViewController

- (void)backSearchParameterAction:(void(^)(NSDictionary *saveDic))action;

@property (nonatomic, strong) NSDictionary *saveDic;

@end
