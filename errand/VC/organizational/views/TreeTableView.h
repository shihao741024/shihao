//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Node;
//@class TreeModel

@protocol TreeTableCellDelegate <NSObject>

@required
-(void)cellClick : (Node *)node andIndexpath:(NSIndexPath *)indexpath;

@optional
- (void)departmentSelectWithSelectArray:(NSMutableArray*)selectArray;

- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath node:(Node *)node;

@end


@interface TreeTableView : UITableView

@property (nonatomic, assign) BOOL searchVisitRecord;
//多选时候选中的node数组
@property (nonatomic, strong) NSMutableArray *multipleSelectArray;

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

@property (nonatomic, assign)int type; // 1 下级部门  2 针对于 选择部门

@property (nonatomic , strong)NSMutableArray *departmentSelectArray;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

- (void)tableviewReloadWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexpath andParentId:(int)parentId andSourceArray:(NSArray *)sourceArray;

@property (nonatomic, strong) NSMutableArray *selectDicArray;

@end
