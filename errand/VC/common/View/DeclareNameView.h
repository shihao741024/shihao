//
//  DeclareNameView.h
//  errand
//
//  Created by wjjxx on 16/3/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeclareNameViewDelegate <NSObject>

- (void)selectDeclareName:(NSString*)name ;

@end


@interface DeclareNameView : UIView<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@property (nonatomic, weak) id <DeclareNameViewDelegate>delegate;

@end
