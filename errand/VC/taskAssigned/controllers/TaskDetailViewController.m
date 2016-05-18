//
//  TaskDetailViewController.m
//  errand
//
//  Created by gravel on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskBll.h"
#import "MMAlertView.h"
#import "MMPopupView.h"
@interface TaskDetailViewController ()
@end

@implementation TaskDetailViewController{
     float bottomHeight ;
    float topHeight;
    UIScrollView *_scrollView;
    UIView *_progressBgView;
    UITableView *_tableView;
}
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"taskDetail", @"taskDetail");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    bottomHeight= 60;
    topHeight = 20;
    [self initData];
   
    // Do any additional setup after loading the view.
}

- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)initData{
    [self showHintInView:self.view];
    TaskBll *taskBll = [[TaskBll alloc]init];
    [taskBll getDetailTaskData:^(TaskDetailModel *model) {
        _taskModel = model;
        [self createMainView];
        [self createBottomView];
        [self hideHud];
    } taskID:_taskID viewCtrl:self];
}
- (void)createMainView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight)];
    _scrollView.backgroundColor = [UIColor  whiteColor];
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.layer.cornerRadius = 15;

    [self createTaskDetailMainViewWithBgView:_scrollView andWithType:type andWithTaskModel:self.taskModel];
}


- (void)createBottomView{
    
//    0 待接收 1 已接受 99已完成 3拒绝  -1 过期 -2取消
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomHeight-topHeight, SCREEN_WIDTH, bottomHeight+topHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bottomHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:topView];
    switch ([self.taskModel.stauts intValue]) {
        case 0:{
            [self createBottomViewWithBottonView:topView andWithLeftNormalImageName:@"backout" andWithLeftSelectedImageName:@"backout" andWithRightNormalImageName:@"agree" andWithRightSelectedImageName:@"agree"];
            float lengthData;
            if (SCREEN_WIDTH > 375) {
                lengthData  = (self.view.frame.size.width-20)/8;
            }else{
                lengthData = (self.view.frame.size.width-20)/7;}
            
            UILabel *leftLabel = [[UILabel alloc]init];
            if (type == 0) {
                leftLabel.text = NSLocalizedString(@"backout", @"backout");
            }else{
                leftLabel.text = NSLocalizedString(@"reject", @"reject");
            }
            
            leftLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
            leftLabel.font = [UIFont systemFontOfSize:15];
            leftLabel.textColor = [UIColor grayColor];
            leftLabel.textAlignment = NSTextAlignmentCenter;
            [bottomView addSubview:leftLabel];
            UILabel *rightLabel = [[UILabel alloc]init];
            if (type == 0) {
                rightLabel.text = NSLocalizedString(@"remind", @"remind");
            }else{
                rightLabel.text = NSLocalizedString(@"receive", @"receive");
            }
            
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
            bottomView.hidden = NO;
            _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
        }
            
            break;
        case 1:{
            if (type == 1) {
                _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
                
                UILabel *completeLbl = [[UILabel alloc]init];
                completeLbl.text = NSLocalizedString(@"complete", @"complete");
                completeLbl.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
                completeLbl.font = [UIFont systemFontOfSize:15];
                completeLbl.textColor = [UIColor grayColor];
                completeLbl.textAlignment = NSTextAlignmentCenter;
                [bottomView addSubview:completeLbl];
                                        
                UIButton *completeBtn = [[UIButton alloc]init];
                [completeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
                [topView addSubview:completeBtn];
                [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                float lengthData;
                if (SCREEN_WIDTH > 375) {
                    lengthData  = (self.view.frame.size.width-20)/8;
                }else{
                    lengthData = (self.view.frame.size.width-20)/7;}
                
                [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(topView);
                    make.width.equalTo(lengthData);
                    make.height.equalTo(lengthData);
                    make.centerY.equalTo(topView);
                }];
                [completeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(bottomView);
                    make.width.equalTo(bottomView.mas_width);
                    make.height.equalTo(15);
                    make.bottom.equalTo(bottomView.mas_bottom).offset(-5);
                    
                }];
                
            }
            bottomView.hidden = NO;
           
        }
            break;
        default:
        {//其他状态不建立底部
            bottomView.backgroundColor = COMMON_BACK_COLOR;
            topView.backgroundColor = COMMON_BACK_COLOR;
            bottomView.hidden = YES;
            _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 10 -10 - 10);
        }
            break;
    }
    
    
    
}
// 接收是0 拒绝是1 撤销是2 完成是3 提醒是4
-(void)leftButtonClick{
       TaskBll *taskBll = [[TaskBll alloc]init];
    if (type == 0) {
        [self showHintInView:self.view];
        [taskBll dealTaskData:^(int result) {
            [Dialog simpleToast:@"撤销成功"];
            self.changeStatusBlock(self.indexPath,@"-2");
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } taskID:_taskID dealType:2 feedback:nil viewCtrl:self];
    }else{
        MMAlertView *alterView = [[MMAlertView alloc]initWithInputTitle:@"请输入驳回理由" detail:@"" placeholder:@"" handler:^(NSString *text) {
            if (text.length != 0) {
                [self showHintInView:self.view];
                [alterView show];
                [taskBll dealTaskData:^(int result) {
                    [Dialog simpleToast:@"驳回成功"];
                    self.changeStatusBlock(self.indexPath,@"3");
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } taskID:_taskID dealType:1 feedback:text viewCtrl:self];
            }
        }];
        
        [alterView show];
    }
    
}

-(void)rightButtonClick{
    [self showHintInView:self.view];
    TaskBll *taskBll = [[TaskBll alloc]init];
    if (type == 0) {
        [taskBll dealTaskData:^(int result) {
            
//            self.changeStatusBlock(self.indexPath,@"1");
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            [Dialog simpleToast:@"提醒成功"];
        } taskID:_taskID dealType:4 feedback:nil viewCtrl:self];
    }else{
        [taskBll dealTaskData:^(int result) {
            self.changeStatusBlock(self.indexPath,@"1");
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
           [Dialog simpleToast:@"接收成功"];
        } taskID:_taskID dealType:0 feedback:nil viewCtrl:self];
    }
    
    
}

- (void)completeBtnClick{
    TaskBll *taskBll = [[TaskBll alloc]init];
    __block MMAlertView *view;
    MMAlertView *alterView = [[MMAlertView alloc]initWithInputTitle:@"备注" detail:@"" placeholder:@"" handler:^(NSString *text) {
        
        
        [view hide];
        [self showHintInView:self.view];
        [taskBll dealTaskData:^(int result) {
            self.changeStatusBlock(self.indexPath,@"99");
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            [Dialog simpleToast:@"完成任务"];
            
            [alterView hide];
            
        } taskID:_taskID dealType:3 feedback:text viewCtrl:self];
        
    }];
    view = alterView;
    [alterView show];
}

-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.text = text;
    label.textAlignment = alignment;
    return label;
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
