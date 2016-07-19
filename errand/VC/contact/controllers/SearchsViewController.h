//
//  SearchsViewController.h
//  errand
//
//  Created by 医路同行Mac1 on 16/6/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchsViewController : UIViewController
@property (nonatomic, copy)NSArray *searchArray;
//@property (nonatomic, assign)int type;
@property (nonatomic, assign)int row1;

@property (nonatomic, copy)void (^feedBackHospitalSearchDataBlock)(NSString *keywords,NSString *hospitalrank,NSString *province,NSString *city);


@end
