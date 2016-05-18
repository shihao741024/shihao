//
//  InformatiionDetailVC.m
//  errand
//
//  Created by wjjxx on 16/3/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "InformatiionDetailVC.h"
#import "InformationBll.h"
#import "InformationDetailTableViewCell.h"
#import "InformationModel.h"
#import "MissionDetailViewController.h"
#import "TaskDetailViewController.h"
#import "DeclareDetailViewController.h"
@interface InformatiionDetailVC ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>

@end

@implementation InformatiionDetailVC{
    NSMutableArray *_dataArray;
    int pageIndex;
    SRRefreshView *_slimeView;
    UITableView *_tableView;
    BOOL isExpand;
    
    //底部视图
    UIView *_bottomView;
    UIButton *_cancelBtn;
    UIButton *_deleteBtn;
    
    NSMutableArray *_selectedArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
//     UIImage *image = [[UIImage imageNamed:@"edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(editClick)];
    
    if (_type != 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    }
    
    // Do any additional setup after loading the view.
}
- (void)editClick{
    if (isExpand == NO) {
        isExpand = YES;
        [self createBottomView];
        
        //把表格的高度变短
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_tableView setHeight:SCREEN_HEIGHT-64-80];
            }];
        });
        }else{
        isExpand = NO;
        //以动画的形式隐藏起来
        [UIView animateWithDuration:0.5 animations:^{
            _bottomView.frame =  _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 80);
        }];
        //把之前选中的模型去掉
        for (InformationModel *model in _selectedArray) {
            model.isEdit = NO;
        }
    }
    //把表格的高度变回
    _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    [_tableView reloadData];
}
- (void)createBottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 80)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_cancelBtn setImage:[UIImage imageNamed:@"message_cancel"] forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 20);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
        //设置title在button上的位置（上top，左left，下bottom，右right）
        
        _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(50, -40, 0, 0);
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
        [_bottomView addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 80, 80)];
        [_deleteBtn setImage:[UIImage imageNamed:@"message_delete"] forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 20);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_deleteBtn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
        //设置title在button上的位置（上top，左left，下bottom，右right）
        
        _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(50, -40, 0, 0);
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
        [_bottomView addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //以动画的形式展现出来
        [UIView animateWithDuration:0.5 animations:^{
            
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 60-20, SCREEN_WIDTH, 80);

        }];
        
    }else{
        //以动画的形式展现出来
        [UIView animateWithDuration:0.5 animations:^{
            
             _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 60-20, SCREEN_WIDTH, 80);
        }];
    }
}
//取消
- (void)cancelBtnClick{
    
    isExpand = NO;
    //以动画的形式隐藏起来
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.frame =  _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 80);
        
    }];
    for (InformationModel *model in _selectedArray) {
        model.isEdit = NO;
    }
    //把表格的高度变回
    _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    [_tableView reloadData];

}
//把勾选的删除
- (void)deleteBtnClick{
   
    if (_selectedArray.count > 0) {
        [self showHintInView:self.view];
        NSMutableArray *ids = [NSMutableArray array];
        for (InformationModel *model in _selectedArray) {
            [ids addObject:model.InformationID];
        }
        InformationBll *bll = [[InformationBll alloc]init];
        [bll deleteInformationData:^(int result) {
            
            [self hideHud];
            isExpand = NO;

            //以动画的形式隐藏起来
            [UIView animateWithDuration:0.5 animations:^{
                _bottomView.frame =  _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 80);
                
            }];
            [Dialog simpleToast:@"删除成功"];
            [_dataArray removeObjectsInArray:_selectedArray];
            //把表格的高度变回
            _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
            [_tableView reloadData];
            
        } ids:ids viewCtrl:self];
    }else{
        [Dialog simpleToast:@"删除的短信不能小于一条"];
    }
    
}
- (void)initView{
    _dataArray=[[NSMutableArray alloc] init];
    _selectedArray = [[NSMutableArray alloc]init];
    [self addBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64 ) style:UITableViewStylePlain];
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView  setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
    [self createSlime];
    [self createMJ];
    [self initData];
}
- (void)initData{
    if(!pageIndex){
        [self showHintInView:self.view];
        pageIndex=1;
        
    }else if(pageIndex==1){
        
        [self showInfica];
    }else{
        [self showInfica];
    }
    NSNumber* category = 0;
    if (_type == 0) {
        category = @2;
    }else if (_type == 1){
        category = @0;
    }else if (_type == 2){
        category = @1;
    }
    InformationBll *infomationBll = [[InformationBll alloc]init];
    [infomationBll getInformationData:^(NSArray *arr) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        [self hideHud];
        [_tableView reloadData];
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } pageIndex:pageIndex category:category viewCtrl:self];
}

-(void)createSlime{
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset =0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor grayColor];
    _slimeView.slime.skinColor = [UIColor grayColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor grayColor];
    
    [_tableView addSubview:_slimeView];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[InformationDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    InformationModel *model = _dataArray[indexPath.row];
    [cell setInformationModel:model isExpand:isExpand];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __block InformationDetailTableViewCell *mycell = cell;
    cell.informationSelectClick= ^ {
        if (model.isEdit == YES) {
            model.isEdit = NO;
            [mycell.selectedBtn setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
            [_selectedArray removeObject:model];
        }else{
            model.isEdit = YES;
            [mycell.selectedBtn setImage:[UIImage imageNamed:@"itemchoice_checked"] forState:UIControlStateNormal];
            [_selectedArray addObject:model];
        }

    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationModel *model = _dataArray[indexPath.row];
    CGSize size = [self sizeWithString:model.content font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 16 - 80, MAXFLOAT)];
    return size.height > 50 ? 30+size.height+2 : 30+50+2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type == 0) {
        return;
    }
    
    if (isExpand == NO) {
        InformationModel *model = _dataArray[indexPath.row];
        NSArray *arr = [model.data componentsSeparatedByString:@","];
        if ([arr[0] isEqualToString:@"trip"]) {
            MissionDetailViewController *vc = [[MissionDetailViewController alloc]init];
            vc.missionID = [NSNumber numberWithInt:[arr[1] intValue]];
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
            
            [vc setChangeMissionStatusBlock:^(NSIndexPath *inde, int cate, MissionModel *mo) {
                
            }];
            
            [vc setDeleteMissionDataBlock:^(NSIndexPath *inde) {
                
            }];
        }else if ([arr[0] isEqualToString:@"task"]){
            
            TaskDetailViewController *vc = [[TaskDetailViewController alloc]init];
            vc.type = 2;
            vc.taskID = [NSNumber numberWithInt:[arr[1] intValue]];
            [self.navigationController pushViewController:vc animated:YES];
            
            [vc setChangeStatusBlock:^(NSIndexPath *inde, NSString *str) {
                
            }];
        }else if ([arr[0] isEqualToString:@"cost"]){
            
            DeclareDetailViewController *vc = [[DeclareDetailViewController alloc]init];
            vc.type = 2;
            vc.declareID = [NSNumber numberWithInt:[arr[1] intValue]];
            [self.navigationController pushViewController:vc animated:YES];
            
            [vc setChangeDeclareStatusBlock:^(NSIndexPath *inde, NSNumber *num, NSString *str) {
                
            }];
            
            [vc setEditFinishRefreshCB:^{
                
            }];
    }
   
    }
    
    
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    [_slimeView scrollViewDidScroll];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    pageIndex=1;
    [self initData];
}


#pragma mark 上拉加载
-(void)createMJ{
    __block  InformatiionDetailVC *salesVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [salesVC initData];
    }];
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
