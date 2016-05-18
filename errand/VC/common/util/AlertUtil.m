//
//  AlertUtil.m
//  errand
//
//  Created by gravel on 16/1/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AlertUtil.h"
#import "MMPopupWindow.h"
#import "MMAlertView.h"
#import "MMPopupItem.h"

@implementation AlertUtil
+(void)alertBody:(NSString*)str{
    [self alertBody:str block:^(NSInteger index){
        
        
    } ];
}

+(void)alertBody:(NSString*)str block:(MMPopupItemHandler)block{
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    NSArray *items =
    @[ MMItemMake(@"我知道了", MMItemTypeHighlight,block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:str
                                                          items:items
                              ];
    [alertView showWithBlock:^(MMPopupView *a) {
        
    }];
}
@end
