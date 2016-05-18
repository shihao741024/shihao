//
//  declareBll.h
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "DeclareModel.h"
#import "DeclareDetailModel.h"
@interface DeclareBll : RequestUtil

- (void)getAllDeclareData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

-(void)addDeclareData:(void (^)(DeclareModel *model))result  Name:(NSString*)Name Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production description:(NSString*)description  cost:(NSString*)cost goal:(NSString*)goal remark:(NSString *)remark viewCtrl:(id)viewCtrl declareID:(NSNumber *)declareID;

- (void)getDeclareDetailData:(void (^)(DeclareDetailModel *model))result declareID:(NSNumber*)declareID viewCtrl:(id)viewCtrl;

- (void)dealDeclareData:(void(^)(int result))result  DeclareID:(NSNumber*)DeclareID dealType:(int)dealType message:(NSString*)message cost:(NSString *)cost  viewCtrl:(id)viewCtrl;

//搜索
- (void)getSearchDeclareData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex name:(NSString*)name Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production description:(NSString*)description goal:(NSString*)goal remark:(NSString *)remark status:(NSNumber*)status viewCtrl:(id)viewCtrl;
@end
