//
//  SearchResultViewController.h
//  errand
//
//  Created by 医路同行Mac1 on 16/6/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductionModel.h"
#import "ContactModel.h"
#import "DoctorModel.h"

@interface SearchResultsViewController : UIViewController
@property (nonatomic, assign)int type;
@property(nonatomic,strong)ProductionModel *productModel;
@property(nonatomic,strong)DoctorModel *doctorModel;
@property (nonatomic, assign) NSInteger popIndex;

//用于搜索的关键字
@property (nonatomic, strong)NSString *keywords;
@property (nonatomic, strong)NSString *kind;
@property (nonatomic, strong)NSString *department;
@property (nonatomic, strong)NSString *hospitalrank;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;

@end
