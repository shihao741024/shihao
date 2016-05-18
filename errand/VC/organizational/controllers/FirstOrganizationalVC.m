//
//  FirstOrganizationalVC.m
//  errand
//
//  Created by gravel on 16/1/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "FirstOrganizationalVC.h"
#import "OrganizationBll.h"
#import "TreeTableView.h"
#import "Node.h"
#import "OrganizationalChildViewController.h"
#import "StaffModel.h"
#import "SalesDailyBll.h"

@interface FirstOrganizationalVC () <TreeTableCellDelegate>

@end

@implementation FirstOrganizationalVC {
    
    NSMutableArray * _dataArray;
    TreeTableView *_tableview;
    
    NSMutableArray *_multipleSelectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self initData];
    if (_type == 1||_type == 2) {
        [self addBackButton];
    }
    // Do any additional setup after loading the view.
}
- (void)initData{
    [self showHintInView:self.view];
     OrganizationBll *organizationBll = [[OrganizationBll alloc]init];
    if (_type == 1) {
        
        [organizationBll getMyTreeData:^(NSArray *arr) {
            [self hideHud];
            _dataArray = [NSMutableArray arrayWithArray:arr];
            [self createTreeTableViewWithData:_dataArray];
        } viewCtrl:self];
    }else{
        [organizationBll getFirstOrgnizationData:^(NSArray *arr) {
            [self hideHud];
            _dataArray = [NSMutableArray arrayWithArray:arr];
            [self createTreeTableViewWithData:_dataArray];
        } viewCtrl:self];
    }
    
}

- (void)createTreeTableViewWithData:(NSArray *)array {
    _tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) withData:array];
    _tableview.searchVisitRecord = _searchVisitRecord;
    _tableview.treeTableCellDelegate = self;
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = COMMON_BACK_COLOR;
    _tableview.selectDicArray = _selectDicArray;
    
    [self.view addSubview:_tableview];
    
    if (_searchVisitRecord) {
        _tableview.allowsMultipleSelection = YES;
        _tableview.frame = CGRectMake(0, 64, kWidth, kHeight-64);
        _multipleSelectArray = [NSMutableArray array];
        _tableview.multipleSelectArray = _multipleSelectArray;
        [self addRightItem];
    }
    
    if (_selectCarryPeople) {
        _tableview.frame = CGRectMake(0, 64, kWidth, kHeight-64);
    }
}

- (void)addRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(multipleSelectFinish)];
}

- (void)multipleSelectFinish
{
    NSMutableArray *staffDicArray = [NSMutableArray array];
    for (Node *node in _multipleSelectArray) {
        NSDictionary *dic = @{@"name": node.name,
                              @"ID": [NSNumber numberWithInt:node.nodeId]};
        [staffDicArray addObject:dic];
    }
    _feedBackStaffArrayCB(staffDicArray);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node andIndexpath:(NSIndexPath *)indexpath{
//    NSLog(@"%d",[_dataArray[2] hasRequest]);
    
    
    
    if (node.telephone) {
        if (_type == 1) {
            
            NSArray  *array = @[node.name,[NSNumber numberWithInt:node.nodeId],node.telephone];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:array forKey:@"staffInfo"];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            
        }else if (_type == 2){
            if (_selectCarryPeople) {
                NSArray *vcs = self.navigationController.viewControllers;
                [self.navigationController popToViewController:vcs[vcs.count - 3] animated:YES];
                self.feedBackStaffInfoBlock(node.name,[NSNumber numberWithInt:node.nodeId]);
                return;
            }
            
            if (_searchVisitRecord) {
                if (node.telephone) {
                    if ([_multipleSelectArray indexOfObject:node] == NSNotFound) {
                        node.satffSelected = YES;
                        [_multipleSelectArray addObject:node];
                    }
                }
                return;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            self.feedBackStaffInfoBlock(node.name,[NSNumber numberWithInt:node.nodeId]);
        }
        else{
            OrganizationalChildViewController *vc = [[OrganizationalChildViewController alloc]init];
            StaffModel *model = [[StaffModel alloc]init];
            model.companyName = @"医路行";
            model.state = @"在职";
            model.email = 
            model.positionName = [NSString stringWithFormat:@"%@",node.quantity];
            model.staffName = node.name;
            model.phoneNumber = node.telephone;
            model.departmentName = node.department;
            model.weixin = node.weixin;
            model.email = node.email;
            vc.staffModel = model;
             [self.navigationController pushViewController:vc animated:YES];
        }
        
    }

    if (!node.hasChildrenNode) {
        return;
    }
    
    if (!node.hasRequest) {
    
        
        OrganizationBll *organizationBll = [[OrganizationBll alloc]init];
        [organizationBll getAboutSalesData:^(NSArray *arr) {
            
//            [_dataArray[indexpath.item] setHasRequest:YES];
            for (int i = 0; i < _dataArray.count; i++) {
                if (([_dataArray[i] nodeId] == node.nodeId) && ([_dataArray[i] parentId] == node.parentId)) {

                    [_dataArray[i] setHasRequest:YES];
                    break;
                }
                
            }
            
//            NSLog(@"click   %d",node.hasChildrenNode);
            NSMutableArray * array = [NSMutableArray array];
//            NSArray * tempArray = [NSArray arrayWithArray:_dataArray];
            for (Node * item in arr) {

                item.depth = node.depth + 1;
                item.expand = YES;
                [array addObject:item];
//                NSLog(@"%d", item.depth);
            }
            [_tableview tableviewReloadWithArray:array andIndexpath:indexpath andParentId:node.nodeId andSourceArray:_dataArray];
        } salesId:[NSNumber numberWithInt:node.nodeId] viewCtrl:self];
        
        
    } else {
        for (int i = 0; i < _dataArray.count; i++) {
//            if (([_dataArray[i] nodeId] == node.nodeId) && ([_dataArray[i] parentId] == node.parentId)) {
//                Node * model = [_dataArray[i] copy];
//                [model setHasRequest:NO];
//                [_dataArray replaceObjectAtIndex:i withObject:model];
//                break;
//                [_dataArray[i] setHasRequest:NO];
//            }
            if ([_dataArray[i] expand] == NO) {
                [_dataArray[i] setHasRequest:NO];
            }
        }
//        [_dataArray[indexpath.item] setHasRequest:NO];
//        for (int i = 0; i < _dataArray.count; i++) {
//            if (([_dataArray[i] nodeId] == node.nodeId) && ([_dataArray[i] parentId] == node.parentId)) {
//                Node * model = [_dataArray[i] copy];
//                [model setHasRequest:NO];
//                [_dataArray replaceObjectAtIndex:i withObject:model];
//                break;
//                [_dataArray[i] setHasRequest:NO];
//            }
//        }
        
//        if (node.parentId == -1) {
//            [_dataArray[0] setHasRequest:NO];
//        }
    }
    
}

- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath node:(Node *)node
{
    if (_searchVisitRecord) {
        if (node.telephone) {
            if ([_multipleSelectArray indexOfObject:node] != NSNotFound) {
                node.satffSelected = NO;
                [_multipleSelectArray removeObject:node];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
