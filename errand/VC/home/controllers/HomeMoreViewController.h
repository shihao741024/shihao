//
//  HomeMoreViewController.h
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"

@interface HomeMoreViewController : BaseNoTabViewController

@property (nonatomic,retain)NSArray *hadArray;

@property(nonatomic,copy)void (^setNewChangeClock)(NSArray*arr);

@end
