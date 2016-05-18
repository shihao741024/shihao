//
//  ContactViewController.h
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "ProductionModel.h"
#import "ContactModel.h"
#import "DoctorsModel.h"
@interface ContactViewController : BaseNoTabViewController

@property(nonatomic,assign)int type; //0 通讯录 1 直接 选择医院 调回 2 直接选择医院 并跳到医生 3 从产品 选择医院 调回 4 从产品 选择医院 跳到医生 //5 竞品  6 可以打勾 也可以跳到医生 ,7选择医院list 8,list选择医生
@property(nonatomic,strong)ProductionModel *productModel;

@property(nonatomic,strong)ContactModel *contactModel;

@property (nonatomic, copy)void (^feedBackContactModelBlock)(ContactModel *contactModel);

@property (nonatomic, copy)void (^feedBackDoctorsModelBlock)(DoctorsModel *doctorsModel);

@property (nonatomic, copy)void (^feedBackHospitalAndDoctor)(ContactModel *contactModel, DoctorsModel *doctorsModel);

@property (nonatomic, assign) BOOL phonebook;

@property (nonatomic, assign)BOOL allProduct;


@property (nonatomic, assign) NSInteger popIndex;

@end
