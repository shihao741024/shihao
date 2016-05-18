//
//  UserBLL.h
//  errand
//
//  Created by gravel on 16/1/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"

@interface UserBLL : RequestUtil
-(void)login:(void (^)(int  result))result  username:(NSString*)username password:(NSString*)password viewCtrl:(id)viewCtrl;
-(void)logout:(void (^)(int  result))result  username:(NSString*)username viewCtrl:(id)viewCtrl;
- (void)modifyPW:(void (^)(int result))result oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword viewCtrl:(id)viewCtrl;
- (void)getQiniuTokenWithData:(NSData*)data result:(void (^)(int result))result viewCtrl:(id)viewCtrl;
@end
