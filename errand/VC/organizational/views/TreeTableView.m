//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "Node.h"
#import "MyTreeTableViewCell.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@end

@implementation TreeTableView {
    
    NSUInteger _index;
    NSArray * _tempArray;
}

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _departmentSelectArray = [NSMutableArray array];
        _data = [NSMutableArray arrayWithArray:data];
        _tempData = [self createTempData:data];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}

- (void)tableviewReloadWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexpath andParentId:(int)parentId andSourceArray:(NSArray *)sourceArray{

    if (array.count == 0) {
        return;
    }
    
    int childrenCount = 0;
    for (int i = 0; i < sourceArray.count; i++) {
        if ([_data[i] parentId] == parentId) {
            childrenCount++;
        }
    }
    BOOL flag = YES;
    for (int i = 0; i < _data.count; i++) {
        if (([array[0] nodeId] == [_data[i] nodeId]) && ([array[0] parentId] == [_data[i] parentId]) && ([[array[0] name] isEqualToString:[_data[i] name]])) {
            flag = NO;
            break;
        } 
    }
    if (flag) {
        [_data addObjectsFromArray:array];
        int count = (int)(_tempData.count);
        for (int i = count - 1; i >=0; i--) {
            if ([array[0] parentId] == [_tempData[i] nodeId]) {
                for (int j = 0; j < array.count; j++) {
                    [_tempData insertObject:array[j] atIndex:indexpath.row + j + childrenCount + 1];
                }
                break;
            }
        }
    }
    
    
    
    
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Node *node = [_tempData objectAtIndex:indexPath.row];
    MyTreeTableViewCell * cell;
    if (node.telephone) {
        static NSString * personCell = @"personCell";
        cell = [tableView dequeueReusableCellWithIdentifier:personCell];
        
        if (!cell) {
            cell = [[MyTreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personCell andType:1];
            cell.searchVisitRecord = _searchVisitRecord;
            [cell resetButtonImage];
        }
        
        // 根据节点的深度，为该节点对应 cell 添加缩进
//        NSMutableString *blankStr = [NSMutableString string];
//        for (int i = 0; i < node.depth; i++) {
//            [blankStr appendFormat:@"    "];
//        }
        
        CGFloat blankW = 10+44;
        for (int i = 0; i < node.depth; i++) {
            blankW = blankW+25;
        }
        cell.nameLabel.frame = CGRectMake(blankW, 13, kWidth, 22);
        cell.phoneNumLabel.frame = CGRectMake(blankW, 35, kWidth, 22);
        cell.iconImgView.frame = CGRectMake(blankW-10-44, (70-44)/2.0, 44, 44);
        
        [cell.iconImgView sd_setImageWithURL:(NSURL *)node.avatar placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
        cell.nameLabel.text = node.name;
        cell.phoneNumLabel.text = node.telephone;
        
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@", blankStr, node.name];
//       
//        cell.phoneNumLabel.text = [NSString stringWithFormat:@"%@%@", blankStr, node.telephone];
        
        cell.callPhoneBlock = ^(){
            [self openCall:node.telephone];
        };
        
        if (_selectDicArray) {
            
        }
        
    } else {
        
        static NSString * departmentCell = @"departmentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:departmentCell];
        
        if (!cell) {
            //当type = 2  选择全部部门
            if (_type == 2) {
                cell = [[MyTreeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:departmentCell andType:2];
            }else if (_type == 1){
                cell = [[MyTreeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:departmentCell andType:3];
               
            }
            else{
                cell = [[MyTreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:departmentCell andType:0];

            }
           //cell.arrowImageView.transform = CGAffineTransformMakeTranslation(node.depth * 20, 0);
            
        }
        if (_type == 1) {
             [cell createCellForMyTreeWithModel:node];
        }
        
        //树是否展开
        BOOL flag = YES;
        for (int i = 0; i < _data.count; i++) {
            if ([_data[i] parentId] == node.nodeId) {
                flag = NO;
                break;
            }
        }
        
        if (flag) {
//            cell.arrowImageView.hidden = YES;
            [self changeCellBackgroundColor:cell flag:NO];
            if (node.nodeId != -1) {
//                cell.arrowImageView.frame = CGRectMake(node.depth * 20 + 10, 30, 10, 10);
//                cell.arrowImageView.transform = CGAffineTransformMakeTranslation(node.depth * 20, 0);
            }
        } else {
            cell.arrowImageView.hidden = NO;
            cell.arrowImageView.transform = CGAffineTransformMakeTranslation(node.depth * 20, 0);
            
            for (int i = 0; i < _tempData.count; i++) {
                if ([_tempData[i] parentId] == [_tempData[indexPath.row] nodeId]) {
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                cell.arrowImageView.image = [UIImage imageNamed:@"tree_ex"];
                
            } else {
                cell.arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
                
            }
            [self changeCellBackgroundColor:cell flag:flag];
        }
        
        // 根据节点的深度，为该节点对应 cell 添加缩进
//        NSMutableString *blankStr = [NSMutableString string];
//        for (int i = 0; i < node.depth; i++) {
//            [blankStr appendFormat:@"    "];
//        }
        
        CGFloat blankW = 0;
        for (int i = 0; i < node.depth; i++) {
            blankW = blankW+25;
        }
        cell.departmentNameLabel.text = node.name;
        cell.arrowImageView.frame = CGRectMake(blankW, 20, 10, 10);
        
        if (_type == 2) {//有后面的selectButton
            cell.departmentNameLabel.frame = CGRectMake(blankW+10, 0, kWidth-(blankW+10)-30-20, 50);
        }else if (_type == 1){//有后面的selectButton
            cell.departmentNameLabel.frame = CGRectMake(blankW+10, 0, kWidth-(blankW+10)-30-20, 50);
            
        }else{//没有后面的selectButton
            cell.departmentNameLabel.frame = CGRectMake(blankW+10, 0, kWidth-(blankW+10), 50);
        }
//        cell.departmentNameLabel.text = [NSString stringWithFormat:@"%@%@", blankStr, node.name];
        
        //如果部门被选中 图片为选中状态 如果不是 就是未选中图片    防止复用状态
        if (node.dSelect == YES) {
            [cell.selectButton setImage:[UIImage imageNamed:@"itemchoice_checked"] forState:UIControlStateNormal];
        }else{
            [cell.selectButton setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
        }
    }
    
    //选择部门的时候 
    if (_type == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //选中按钮被点中时，修改相应数据
    __weak MyTreeTableViewCell *weakCell = cell;
    cell.departmentSelectClick = ^{
        if (node.dSelect == YES) {
            node.dSelect = NO;
            [weakCell.selectButton setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
            for (Node *node2 in _departmentSelectArray) {
                
                if (node2.nodeId == node.nodeId) {
                    [_departmentSelectArray removeObject:node2];
                     break;
                }
            }
        }else {
            node.dSelect = YES;
            [weakCell.selectButton setImage:[UIImage imageNamed:@"itemchoice_checked"] forState:UIControlStateNormal];
            [_departmentSelectArray addObject:node];
            
        }
        if ([self.treeTableCellDelegate respondsToSelector:@selector(departmentSelectWithSelectArray:)]) {
            [self.treeTableCellDelegate departmentSelectWithSelectArray:_departmentSelectArray];
            
        }
    };
    
    if (_searchVisitRecord) {
        if (node.telephone) {
            if (node.satffSelected) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        
    }
    
    
    return cell;
    
    
    
    /*
     // cell有缩进的方法
     //  cell.indentationLevel = node.depth; // 缩进级别
     // cell.indentationWidth = 30.f; // 每个缩进级别的距离
     NSMutableString *name = [NSMutableString string];
     for (int i=0; i<node.depth; i++) {
     [name appendString:@"    "];
     }
     //    [name appendString:node.name];
     */
}

- (void)changeCellBackgroundColor:(UITableViewCell *)cell flag:(BOOL)flag
{
    if (flag) {
        cell.backgroundColor = GDBColorRGB(0, 153/255.0, 204/255.0, 1);
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Node *node = [_tempData objectAtIndex:indexPath.row];
    if (node.telephone) {
          return 70;
    }
     return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    //先修改数据源
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    
    if (_searchVisitRecord) {
        MyTreeTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (parentNode.telephone) {
//            if (cell.selected == YES) {
//                [self deselectRowAtIndexPath:indexPath animated:YES];
//            }else {
//                [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            }
        }else {
            [self deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick: andIndexpath:)]) {
        [_treeTableCellDelegate cellClick:parentNode andIndexpath:indexPath];
    }
    
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
//    if (_tempArray.count > 0) {
//        [_data addObjectsFromArray:_tempArray];
//    }
    if (parentNode.hasChildrenNode) {
        for (int i=0; i<_data.count; i++) {
            Node *node = [_data objectAtIndex:i];
            if (node.parentId == parentNode.nodeId) {
                node.expand = !node.expand;
                if (node.expand) {
                    [_tempData insertObject:node atIndex:endPosition];
                    expand = YES;
                    endPosition++;
                }else{
                    expand = NO;
                    endPosition = [self removeAllNodesAtParentNode:parentNode];
                    break;
                }
            }
        }
    }
    
    
    
    
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    _index = endPosition;
    //插入或者删除相关节点
    if (expand) {
        
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        for (NSIndexPath *item in indexPathArray) {
            MyTreeTableViewCell * cell = [tableView cellForRowAtIndexPath:item];
            cell.arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
            [self changeCellBackgroundColor:cell flag:NO];
        }
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    // 改变箭头
    if (!parentNode.telephone) {
        MyTreeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        BOOL flag = NO;
        for (int i = 0; i < _tempData.count; i++) {
            if ([_tempData[i] parentId] == parentNode.nodeId) {
                flag = YES;
                break;
            }
        }
        
        if (flag) {
            cell.arrowImageView.image = [UIImage imageNamed:@"tree_ex"];
        } else {
            cell.arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
        }
        [self changeCellBackgroundColor:cell flag:flag];
    }
    
//    [self reloadData];
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(didDeselectRowAtIndexPath:node:)]) {
        [_treeTableCellDelegate didDeselectRowAtIndexPath:indexPath node:parentNode];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

//打电话
-(void)openCall:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}
@end
