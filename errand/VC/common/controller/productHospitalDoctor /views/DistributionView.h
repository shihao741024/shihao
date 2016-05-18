//
//  DistributionView.h
//  errand
//
//  Created by gravel on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
@protocol DistributionViewDelegate <NSObject>

- (void)selectPss:(NSString*)pss;

@end

@interface DistributionView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <DistributionViewDelegate>delegate;

@property (nonatomic, strong)NSString *provincial;

@property (nonatomic, strong)NSString *city;

- (instancetype)initWithFrame:(CGRect)frame provincial:(NSString*)provincial city:(NSString*)city;
@end
