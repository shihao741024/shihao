//
//  DetailEdittingViewController.h
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJJDetailEdittingDelegate <NSObject>

- (void)feedBackEditedDetail:(NSString *)string andIndex:(NSInteger)index;

@end

@interface DetailEdittingViewController : UIViewController

@property (nonatomic, weak) id <WJJDetailEdittingDelegate> delegate;
@property (nonatomic, strong) NSString *contentString;
@property NSInteger index;

@end
