//
//  SelectDepartmentVC.m
//  errand
//
//  Created by gravel on 16/3/1.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SelectDepartmentVC.h"
#import "OrganizationBll.h"
#import "TreeTableView.h"
#import "Node.h"
#import "StaffModel.h"
#import "SalesDailyBll.h"
@interface SelectDepartmentVC ()<TreeTableCellDelegate>


@end

@implementation SelectDepartmentVC{
    NSMutableArray * _dataArray;
    TreeTableView *_tableview;
    UIButton *_sureButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"selectDepartment", @"selectDepartment");
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createRightItem];
     [self initData];
}

- (void)createRightItem{
    
    _sureButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, 60, 36)];
    [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)_departmentSelectArray.count] forState:UIControlStateNormal];
    [_sureButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    _sureButton.backgroundColor = COMMON_BLUE_COLOR;
    [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_sureButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)sureButtonClick{
    //把选中的部门回调回去
//      if (_tableview.departmentSelectArray.count > 0) {
    if (_selectCarryPeople) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
     [self.navigationController popViewControllerAnimated:YES];
        self.departmentSelectArrayBlock(_tableview.departmentSelectArray);
          
//    }
   
    
}
- (void)initData{
    [self showHintInView:self.view];
    OrganizationBll *organizationBll = [[OrganizationBll alloc]init];
    if (_type == 0) {
        [organizationBll getFirstOrgnizationData:^(NSArray *arr) {
            [self hideHud];
            _dataArray = [NSMutableArray arrayWithArray:arr];
            
            
            if (_departmentSelectArray.count > 0) {
                for (Node *node in _dataArray) {
                    for (Node *node2 in _departmentSelectArray) {
                        if (node.nodeId == node2.nodeId) {
                            node.dSelect = YES;
                        }
                        
                    }
                }
            }
            
            [self createTreeTableViewWithData:_dataArray];
        } viewCtrl:self];
    }else{
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        [bll getMyTreeData:^(NSArray *arr) {
            [self hideHud];
            _dataArray = [NSMutableArray arrayWithArray:arr];
            
            
            if (_departmentSelectArray.count > 0) {
                for (Node *node in _dataArray) {
                    for (Node *node2 in _departmentSelectArray) {
                        if (node.nodeId == node2.nodeId) {
                            node.dSelect = YES;
                        }
                        
                    }
                }
            }
            
            [self createTreeTableViewWithData:_dataArray];
        } viewCtrl:self];
    }
    
}

- (void)createTreeTableViewWithData:(NSArray *)array {
    _tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withData:array];
    _tableview.treeTableCellDelegate = self;
    if (_type == 1) {
        _tableview.type = 1;
    }else{
        _tableview.type = 2;

    }
    _tableview.departmentSelectArray = _departmentSelectArray;
    //    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = COMMON_BACK_COLOR;
    [self.view addSubview:_tableview];
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node andIndexpath:(NSIndexPath *)indexpath{
    if (!node.hasChildrenNode) {
        return;
    }
        for (int i = 0; i < _dataArray.count; i++) {
           
            if ([_dataArray[i] expand] == NO) {
                [_dataArray[i] setHasRequest:NO];
            }
    }
    
}

- (void)departmentSelectWithSelectArray:(NSMutableArray *)selectArray{
//    _departmentSelectArray = [NSMutableArray arrayWithArray:selectArray];
////    [selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        [_departmentSelectArray addObject:obj];
////    }];
    if (_selectCarryPeople) {
        return;
    }
    
    [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)selectArray.count] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
