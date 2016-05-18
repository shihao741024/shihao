//
//  Node.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  每个节点类型
 */
@interface Node : NSObject

//@property (nonatomic , assign) int parentId;//父节点的id，如果为-1表示该节点为根节点
//
//@property (nonatomic , assign) int nodeId;//本节点的id
//
//@property (nonatomic , strong) NSString *name;//本节点的名称
//
//@property (nonatomic , assign) int depth;//该节点的深度
//
//@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic, assign) BOOL hasRequest;
@property (nonatomic, assign) BOOL hasChildrenNode;
/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL expand;
/**
 *  是否有子节点, 如有则为yes， 若无则表示改节点为叶子节点
 */
@property BOOL leaf;
/**
 *  子节点数组
 */
@property (nonatomic, weak) NSMutableArray *childrenArray;
/**
 *  本节点名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  父节点id,父节点的id，如果为-1表示该节点为根节点
 */
@property (nonatomic, assign) int parentId;
/**
 *  本节点id
 */
@property (nonatomic, assign) int nodeId;


@property (nonatomic , assign) int depth;//该节点的深度

/**
 *  Description
 */
@property NSNumber* quantity;

@property (nonatomic, weak) NSArray *children;


//员工特有的
@property (nonatomic, copy)NSString *telephone;
@property (nonatomic, copy)NSString *department;
@property (nonatomic, assign) BOOL satffSelected;
@property (nonatomic, copy)NSString *avatar;

@property (nonatomic, copy)NSString *weixin;
@property (nonatomic, copy)NSString *email;

/**
 *  判断部门是否被选中
 */
@property (nonatomic)BOOL dSelect;
/**
 *快速实例化该对象模型
 */
//- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand;

- (NSMutableArray *)nodesArrayWithTreeDic:(NSDictionary *)dic;



@end
