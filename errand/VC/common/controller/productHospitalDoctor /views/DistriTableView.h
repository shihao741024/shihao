//
//  DistriTableView.h
//  errand
//
//  Created by gravel on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistriTableViewDelegate <NSObject>

-(void)cellClick : (NSString *)pss;

@end

@interface DistriTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak) id <DistriTableViewDelegate> distriDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style distriArray:(NSMutableArray*)distriArray;

- (void)tableviewReloadWithArray:(NSArray *)array;

@end
