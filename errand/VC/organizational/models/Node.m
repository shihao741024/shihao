//
//  Node.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "Node.h"

@implementation Node {
    NSMutableArray *_dataArray;
    
}



- (NSMutableArray *)nodesArrayWithTreeDic:(NSDictionary *)dic {
    
    // 数据源
    _dataArray = [NSMutableArray array];
    
    // 根节点model
    Node * _model = [[Node alloc] init];
    _model.expand = YES;
    _model.hasRequest = NO;
    _model.leaf = (BOOL)dic[@"leaf"];
    _model.name = dic[@"node"][@"name"];
    _model.parentId = -1;
    _model.nodeId = [dic[@"node"][@"id"] intValue];
    _model.quantity = dic[@"node"][@"quantity"];
    _model.depth = 0;
    _model.hasChildrenNode = (BOOL)dic[@"leaf"];
    
    //一开始都设为未选中
    _model.dSelect = NO;
    
    [_dataArray addObject:_model];
    
    // 判断是否有子节点
    if (_model.leaf) {
        // 获取所有子节点数目，
        //        int n = [self getChildrenCount:dic[@"children"]];
        // 获取所有子节点model, 根节点的父节点为 -1
        [self getChildrenModelWithArray:dic[@"children"] andParentId:_model.nodeId andDepth:1];
        //        NSLog(@"%@", _dataArray);
    }
    
//    NSArray *oneArray = [self createOneData];
//    NSArray * tempArray = [NSArray arrayWithArray:_dataArray];
//    for (Node *node in oneArray) {
//        for (Node * item in tempArray) {
//            if (node.parentId == item.parentId) {
//                //                node.parentId = item.parentId;
//                node.depth = item.depth;
//                NSLog(@"%d", node.parentId);
//                [_dataArray addObject:node];
//                break;
//            }
//            
//            
//            
//        }
//    }
    
    return _dataArray;
}
/**
 *  计算根节点以下所有子节点数
 *
 *  @param array 子节点数组
 *
 *  @return 子节点数
 */
- (int)getChildrenCount:(NSArray *)array {
    
    int n = 0;
    n += array.count;
    for (NSDictionary *dict in array) {
        if (dict[@"leaf"]) {
            n += [self getChildrenCount:dict[@"children"]];
        }
    }
    return n;
}

/**
 *  取出所有除根节点以外所有model
 *
 *  @param array    子节点数组
 *  @param parentId 父节点id
 */
- (void)getChildrenModelWithArray:(NSArray *)array  andParentId:(int)parentId andDepth:(int)depth {
    
    // 通过for循环取出所有节点model，并装入数据源
    for (NSDictionary * item in array) {
        
        Node *model = [[Node alloc] init];
        model.expand = NO;
        model.hasRequest = NO;
        model.leaf = (BOOL)item[@"leaf"];
        model.name = item[@"node"][@"name"];
        model.parentId = parentId;
        model.nodeId = [item[@"node"][@"id"] intValue];
        model.quantity = item[@"node"][@"quantity"];
        model.depth = depth;
        model.hasChildrenNode = (BOOL)item[@"leaf"];
        
        //一开始都设为未选中
        model.dSelect = NO;
        [_dataArray addObject:model];
        
        // 判断该节点下是否还有下一层子节点，若有，则递归，若没有则说明该节点为叶子节点
        if (item[@"leaf"]) {
            [self getChildrenModelWithArray:item[@"children"] andParentId:[item[@"node"][@"id"] intValue] andDepth:depth + 1];
        }
        
    }
}





- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
    }
    return self;
}

@end
