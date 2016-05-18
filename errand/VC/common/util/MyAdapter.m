//
//  MyAdapter.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MyAdapter.h"
#import <UIKit/UIKit.h>

@implementation MyAdapter
+(float)aDapter:(float)old{
    return SCREEN_WIDTH>375?old*1.2:old;
}

+(float)aDapterView:(float)old{
     return SCREEN_WIDTH<=375?old/1.2:old;
}
@end
