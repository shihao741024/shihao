//
//  UIViewController+addBackButton.h
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (addBackButton)
- (void)addBackButton;
- (void)navigationItemClicked:(UIBarButtonItem *)barButtonItem;
-(void)addCloseBtn;
-(void)addCloseButton;
- (void)navigationItemCloseClicked:(UIBarButtonItem *)barButtonItem;
@end
