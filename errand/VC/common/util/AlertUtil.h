//
//  AlertUtil.h
//  errand
//
//  Created by gravel on 16/1/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPopupView.h"
#import "MMPopupItem.h"

@interface AlertUtil : NSObject

+(void)alertBody:(NSString*)str;
+(void)alertBody:(NSString*)str block:(MMPopupItemHandler)block;

@end
