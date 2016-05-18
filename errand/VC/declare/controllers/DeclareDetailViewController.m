//
//  DeclareDetailViewController.m
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DeclareDetailViewController.h"
#import "DeclareBll.h"
//#import "MMAlertView.h"
#import "AuditInfosModel.h"
#import "AgreeDeclareReportView.h"
#import "RejectDeclareReportView.h"
#import "TaskEdittingViewController.h"

@interface DeclareDetailViewController ()
{
    AgreeDeclareReportView *_reportView;
    RejectDeclareReportView *_reportV;
}
@end

@implementation DeclareDetailViewController{
    float bottomHeight ;
    float topHeight;
    UIScrollView *_scrollView;
    DeclareDetailModel *_declareModel;
//    MMAlertView * _reportAlterView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"declareDetail", @"declareDetail");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    bottomHeight = 60;
    topHeight = 20;

    [self initData];
}

- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//编辑按钮点击
- (void)editClick{
    if (_declareModel) {
        //    根据type来复用任务交办的申请页面
        TaskEdittingViewController *taskEditVC = [[TaskEdittingViewController alloc] init];
        NSArray *dataArray = @[NSLocalizedString(@"PRO_Name", @"PRO_Name"), NSLocalizedString(@"Standard", @"Standard"),  NSLocalizedString(@"COST_Client", @"COST_Client"),NSLocalizedString(@"USE_Way",@"USE_Way"),NSLocalizedString(@"BUDGET_Cost",@"BUDGET_Cost"),NSLocalizedString(@"BUDGET_Aim",@"BUDGET_Aim"),NSLocalizedString(@"remarks",@"remarks")];
        taskEditVC.dataArray = dataArray;
        taskEditVC.type = 1;
        taskEditVC.editModel = _declareModel;
        
        [taskEditVC setEditFinishRefreshCB:^{
            
            _editFinishRefreshCB();
        }];
        [taskEditVC setFeedBackDeclareBlock:^(DeclareModel *model) {
            
        }];
        [self.navigationController pushViewController:taskEditVC animated:YES];
    }
}
//删除按钮点击

- (void)deleteClick{
    
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/sale/cost/delete/%@", _declareID];
    [self showHintInView:self.view];
    
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [Dialog simpleToast:@"删除成功"];
        _editFinishRefreshCB();
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        [self hideHud];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
    
}

- (void)initData{
    [self showHintInView:self.view];
    DeclareBll *declareBll = [[DeclareBll alloc]init];
    [declareBll getDeclareDetailData:^(DeclareDetailModel *model) {
        [self hideHud];
        _declareModel = model;
        //我处理的
        if (model.belongtoID != [self getUserID]) {
            
            _type =1;
            
            switch ([model.currentStatus intValue]) {
                case 0:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
                    [self createMainView];
                    [self createBottomView];
                    //并且处于待审批状态,第一步
                }break;
                    
                case 99:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createMainView];
                    break;
                    //并且处于已批准状态
                }
                case 90:
                {
                    //审核并上报
                    BOOL flag = NO;
                    //看自己 是否已经审批过
                    for (AuditInfosModel *auditInfosModel in model.auditInfos) {
                        if ([auditInfosModel.auditID isEqual:[self getUserID]]) {
                            flag = YES;
                            _scrollView = [[UIScrollView alloc]init];
                            _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                            [self createMainView];
                            
                            break;
                            
                        }
                    }
                    if (flag == NO) {
                        _scrollView = [[UIScrollView alloc]init];
                        _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
                        [self createMainView];
                        [self createBottomView];
                        
                    }
                    break;
                    
                }
                case -1:{
                    
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createMainView];
                    break;
                }
                default:
                    break;
            }
            
        }else{
            //我申请的
            _type = 0;
            switch ([model.currentStatus intValue]) {
                case 0:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createMissionRightItems];
                    [self createMainView];
                    
                }
                    break;
                default:{
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createMainView];
                }
                    
                    break;
            }
        }
        
        [self hideHud];
        

    } declareID:self.declareID  viewCtrl:self];
}
- (void)createMainView{
   
    _scrollView.backgroundColor = [UIColor  whiteColor];
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.layer.cornerRadius = 15;
    [self createTaskDetailMainViewWithBgView:_scrollView andWithType:_type andWithDeclareModel:_declareModel];
    
}

- (void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomHeight-topHeight, SCREEN_WIDTH, bottomHeight+topHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bottomHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:topView];

    [self createBottomViewWithBottonView:topView andWithLeftNormalImageName:@"backout" andWithLeftSelectedImageName:@"backout" andWithRightNormalImageName:@"agree" andWithRightSelectedImageName:@"agree"];
    
    float lengthData;
    if (SCREEN_WIDTH > 375) {
        lengthData  = (self.view.frame.size.width-20)/8;
    }else{
        lengthData = (self.view.frame.size.width-20)/7;}
    
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = NSLocalizedString(@"back", @"back");
    leftLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.text = NSLocalizedString(@"agree", @"agree");
    rightLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:rightLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(lengthData);
        make.width.equalTo(lengthData);
        make.height.equalTo(15);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-5);
        
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-lengthData);
        make.width.equalTo(lengthData);
        make.height.equalTo(15);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-5);
    }];
    
}
//0退回 1审核通过并上报 2审核通过

//打回
-(void)leftButtonClick{
    [self showRejectDeclareReportv];
    return;
    
}
- (void)showRejectDeclareReportv {
    if (_reportV == NULL) {
        _reportV = [[RejectDeclareReportView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_reportV];
    }
    _reportV.hidden = NO;
    
    [_reportV buttonClickAction:^(NSInteger index) {
        if (index == 1) {
            [self showHintInView:self.view];
            DeclareBll *declareBll = [[DeclareBll alloc]init];
            [declareBll dealDeclareData:^(int result) {
                [self hideHud];
                [Dialog simpleToast:@"驳回成功"];
                
                NSLog(@"%@",_declareModel.currentStatus);
                
                self.changeDeclareStatusBlock(_indexPath,@-1, @"");
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } DeclareID:_declareID dealType:0 message:_reportV.textView.text cost:nil viewCtrl:self];
        }
    }];
}

- (void)showAgreeDeclareReportView
{
    if (_reportView == nil) {
        _reportView = [[AgreeDeclareReportView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_reportView];
        _reportView.textField.text = _declareModel.moneyString;
    }
    _reportView.hidden = NO;
    
    [_reportView buttonClickAction:^(NSInteger index) {
        if (index == 1) {
            [self showHintInView:self.view];
            
            DeclareBll *declareBll = [[DeclareBll alloc]init];
            [declareBll dealDeclareData:^(int result) {
                [self hideHud];
                [Dialog simpleToast:@"上报成功"];
                self.changeDeclareStatusBlock(_indexPath,@90, _reportView.textField.text);
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } DeclareID:_declareID dealType:1 message:_reportView.textView.text cost:_reportView.textField.text viewCtrl:self];
            
        }else if (index == 2) {
            [self showHintInView:self.view];
            
            DeclareBll *declareBll = [[DeclareBll alloc]init];
            [declareBll dealDeclareData:^(int result) {
                [self hideHud];
                [Dialog simpleToast:@"审批成功"];
                self.changeDeclareStatusBlock(_indexPath,@99, _reportView.textField.text);
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } DeclareID:_declareID dealType:2 message:_reportView.textView.text cost:_reportView.textField.text viewCtrl:self];
        }
    }];
}

//审核通过
-(void)rightButtonClick{
    
    [self showAgreeDeclareReportView];
    return;
    
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
