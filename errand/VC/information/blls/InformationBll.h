//
//  InformationBll.h
//  errand
//
//  Created by wjjxx on 16/3/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "RequestUtil.h"

@interface InformationBll : RequestUtil

-(void)getInformationData:(void (^)( NSArray *arr))successArr  pageIndex:(int)pageIndex category:(NSNumber*)category viewCtrl:(id)viewCtrl;

-(void)deleteInformationData:(void (^)( int result))result ids:(NSArray*)ids viewCtrl:(id)viewCtrl;
@end
