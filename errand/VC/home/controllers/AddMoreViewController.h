//
//  AllFuncViewController.h
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNoTabViewController.h"

@interface AddMoreViewController : BaseNoTabViewController

@property(nonatomic,strong) NSArray *choicedArr;

@property(nonatomic,copy) void (^setNewChangeClock)(NSArray*arr);

@end
