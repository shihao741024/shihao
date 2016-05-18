//
//  ContactChildViewController.h
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "HospitalDetailModel.h"
@interface ContactChildViewController : BaseNoTabViewController

@property (nonatomic, strong)HospitalDetailModel *contactModel;

@property(nonatomic,strong)NSNumber *hospitalID;

@end
