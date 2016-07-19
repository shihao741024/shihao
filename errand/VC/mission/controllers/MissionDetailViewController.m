//
//  MissionDetailViewController.m
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionDetailViewController.h"
#import "MissionDetailTableViewCell.h"
#import "MissionBll.h"
#import "MMPopupView.h"
#import "MissionEdittingViewController.h"
#import "ProcessView.h"

#import "AgreeMissionReportView.h"
#import "RejectDeclareReportView.h"

@interface MissionDetailViewController () {
    RejectDeclareReportView *_reportV;
    AgreeMissionReportView *_reportView;
}

@end

@implementation MissionDetailViewController{
    float bottomHeight ;
    float topHeight;
    UIScrollView *_scrollView;
    UIView *_progressBgView;
//    MMAlertView *_reportAlterView;
    MissionDetailModel *_missionModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"missionDetail", @"missionDetail");
    [self addBackButton];
    [self initData];
    
    
    // Do any additional setup after loading the view.
}

- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//编辑按钮点击
- (void)editClick{
    
    MissionEdittingViewController *edittingVC = [[MissionEdittingViewController alloc]init];
    edittingVC.missionModel = _missionModel;
    edittingVC.indexPath = _indexPath;
    NSArray *dataArray = @[NSLocalizedString(@"startPoint:", @"startPoint:"), NSLocalizedString(@"estination:", @"estination:"), NSLocalizedString(@"startTime:", @"startTime:"), NSLocalizedString(@"endTime:", @"endTime:"), NSLocalizedString(@"wayForBusiness:", @"wayForBusiness:"),NSLocalizedString(@"contentOfBusiness:", @"contentOfBusiness:")];
    edittingVC.dataArray = dataArray;
    [self.navigationController pushViewController:edittingVC animated:YES];
    
}
//删除按钮点击

- (void)deleteClick{
    [self showHintInView:self.view];
    MissionBll *bll = [[MissionBll alloc]init];
    [bll deleteMissionData:^(int result) {
        
        [self hideHud];
        [Dialog simpleToast:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        if (_type != 2) {
          self.deleteMissionDataBlock(_indexPath);
        }
        
    } MissionID:_missionID viewCtrl:self];
}
- (void)initData{
    //    99终审 90审核并上报  0 待审核 -1审核不通过
    [self showHintInView:self.view];
    MissionBll *missionBll = [[MissionBll alloc]init];
    [missionBll getDetailMissionData:^(MissionDetailModel *model) {
        
        _missionModel =  model;
        bottomHeight= 60;
        topHeight = 20;
        
        //我处理的
        if (model.belongtoID != [self getUserID]) {
            switch (model.status) {
                case 0:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
                    [self createTopView];
                    [self createBottomView];
                    //并且处于待审批状态,第一步
                }break;
                    
                case 99:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createTopView];
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
                            [self createTopView];
                            
                            break;
                            
                        }
                    }
                    if (flag == NO) {
                        _scrollView = [[UIScrollView alloc]init];
                        _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10 - 10-topHeight);
                        [self createTopView];
                        [self createBottomView];
                        
                    }
                    break;
                    
                }
                case -1:{
                    
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createTopView];
                    break;
                }
                default:
                    break;
            }
            
        }else{
            //我申请的
            switch (model.status) {
                case 0:
                {
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createMissionRightItems];
                    [self createTopView];
                    
                }
                    break;
                default:{
                    _scrollView = [[UIScrollView alloc]init];
                    _scrollView.frame = CGRectMake(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
                    [self createTopView];
                }
                    
                    break;
            }
        }
        
        [self hideHud];
        
        
    } missionID:_missionID viewCtrl:self];
    
}

- (void)createTopView{
    
    _scrollView.backgroundColor = [UIColor  whiteColor];
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.layer.cornerRadius = 15;
    [self createMissionDetailMainViewWithBgView:_scrollView  andWithMissionModel:_missionModel];
    
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
    leftLabel.text = @"驳回";
    leftLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.text = @"同意";
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

//99终审 90审核并上报 0 待审核 -1审核不通过

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
                MissionBll *missionBll = [[MissionBll alloc]init];
                [missionBll dealMissionData:^(int result, id responseObj) {
                    [self hideHud];
                    [Dialog simpleToast:@"驳回成功"];
                    if (_type != 2) {
                        MissionModel *model = [[MissionModel alloc] initWithDic:responseObj[@"data"]];
                        self.changeMissionStatusBlock(_indexPath,-1, model);
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }failure:^(int failure) {
                    [self hideHud];
                } MissionID:self.missionID dealType:0 message:_reportV.textView.text viewCtrl:self];
            }
    }];
}


-(void)rightButtonClick{
    
    [self showAgreeMissionReportView];
    return;
    
}

- (void)showAgreeMissionReportView {
    if (_reportView == nil) {
        _reportView = [[AgreeMissionReportView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_reportView];
    }
    _reportView.hidden = NO;
    
    [_reportView buttonClickAction:^(NSInteger index) {
        if (index == 1) {
            [self showHintInView:self.view];
            
            MissionBll *missionBll = [[MissionBll alloc]init];
            [missionBll dealMissionData:^(int result, id responseObj) {
                [self hideHud];
                [Dialog simpleToast:@"审核上报成功"];
                if (_type != 2) {
                    MissionModel *model = [[MissionModel alloc] initWithDic:responseObj[@"data"]];
                    self.changeMissionStatusBlock(_indexPath,90, model);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } failure:^(int failure) {
                [self hideHud];
            }  MissionID:self.missionID dealType:1 message:_reportView.textView.text viewCtrl:self];
            
        }else if (index == 2) {
            [self showHintInView:self.view];
            
            MissionBll *missionBll = [[MissionBll alloc]init];
            [missionBll dealMissionData:^(int result, id responseObj) {
                [self hideHud];
                [Dialog simpleToast:@"审核成功"];
                if (_type != 2) {
                    MissionModel *model = [[MissionModel alloc] initWithDic:responseObj[@"data"]];
                    self.changeMissionStatusBlock(_indexPath,99,model);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }failure:^(int failure) {
                [self hideHud];
            } MissionID:self.missionID dealType:2 message:_reportView.textView.text viewCtrl:self];
        }
    }];
}

- (void)createMissionDetailMainViewWithBgView:(UIScrollView*)bgView
                        andWithMissionModel:(MissionDetailModel*)missionModel{
    UIImageView *statusView = [[UIImageView alloc]init];
    statusView.image = [UIImage imageNamed:[NSString stringWithFormat:@"status%d",missionModel.status]];
    [bgView addSubview:statusView];
    UILabel *applyDate= [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight andText:missionModel.applyTime];
    
    [bgView addSubview:applyDate];
    UILabel *proposerLabel = [self createLabelWithFont:18 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:missionModel.proposerName];//[NSString stringWithFormat:@"%@(%@)",missionModel.proposerPhone,missionModel.proposerName]];
    [bgView addSubview:proposerLabel];
    
    UILabel *giveTaskLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:@"申请出差"];
    [bgView addSubview:giveTaskLabel];
    
    UILabel *fromLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:missionModel.from];
    fromLabel.font = [UIFont boldSystemFontOfSize:22];
    [bgView addSubview:fromLabel];
    
    UIImageView *travelTypeView = [[UIImageView alloc]init];
    travelTypeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"travelType%d",missionModel.travelType]];
    [bgView addSubview:travelTypeView];
    
    UILabel *toLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:missionModel.to];
    toLabel.font = [UIFont boldSystemFontOfSize:22];
    [bgView addSubview:toLabel];
    
//    时间标签
    UILabel *startDateLabel = [self createLabelWithFont:17 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentCenter andText:missionModel.startDate];
    [bgView addSubview:startDateLabel];
    
    UILabel *endDateLabel = [self createLabelWithFont:17 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentCenter andText:missionModel.endDate];
    [bgView addSubview:endDateLabel];
    
       [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    [applyDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(statusView.mas_right).offset(10);
        make.height.equalTo(@20);
        
    }];
    
    [proposerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusView.mas_bottom).offset(15);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];
    [giveTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proposerLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    [travelTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giveTaskLabel.mas_bottom).offset(10);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giveTaskLabel.mas_bottom).offset(10);
        make.right.equalTo(travelTypeView.mas_left).offset(-10);
        make.left.equalTo(bgView.mas_left).offset(0);
        make.height.equalTo(@30);
    }];
    
    [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giveTaskLabel.mas_bottom).offset(10);
        make.left.equalTo(travelTypeView.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(0);
        make.height.equalTo(@30);
    }];
   
    [startDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fromLabel.mas_bottom).offset(10);
        make.right.equalTo(travelTypeView.mas_left).offset(-10);
        make.left.equalTo(bgView.mas_left).offset(0);
        make.height.equalTo(@20);
    }];
    
    [endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toLabel.mas_bottom).offset(10);
        make.left.equalTo(travelTypeView.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(0);
        make.height.equalTo(@20);

    }];
    
    UIImageView *imageView1 = [[UIImageView alloc]init];
    [bgView addSubview:imageView1];
    
    CGSize size1 = CGSizeMake(bgView.width - 10, 10);
    UIGraphicsBeginImageContext(size1);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, size1.width, size1.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 10.0);    //开始画线
    CGContextAddLineToPoint(line, bgView.width-10, 10.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startDateLabel.mas_bottom).offset(6);
        make.left.equalTo(bgView.mas_left).offset(5);
        make.width.equalTo(bgView.width - 10);
        make.height.equalTo(@10);
    }];
    
    UILabel *remarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"%@",missionModel.remark]];
    [bgView addSubview:remarkLabel];
    remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    remarkLabel.numberOfLines = 0;
    CGSize size = [self sizeWithString:missionModel.remark font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(bgView.width - 30, MAXFLOAT)];
    //    NSLog(@"%lf",size.height);
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom).offset(6);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(bgView.width - 30);
        make.height.equalTo(size.height+20);
    }];
    if (missionModel.auditInfos.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, remarkLabel.frame.origin.y + size.height + 15);
        });
    }else {
        UILabel *progressLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andText:@"审批流程"];
        [bgView addSubview:progressLabel];
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(10);
            make.top.equalTo(remarkLabel.mas_bottom).offset(15);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [bgView addSubview:lineLabel];
        
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(0);
            make.top.equalTo(progressLabel.mas_bottom).offset(5);
            make.width.equalTo(SCREEN_WIDTH-20);
            make.height.equalTo(@01);
        }];
        CGFloat height = 0.0;
        for (int i = 0; i < missionModel.auditInfos.count; i++) {
            ProcessView *processView = [[ProcessView alloc]init];
            [bgView addSubview:processView];
            
            //流程
            [processView setAuditInfosModelToView:missionModel.auditInfos[i] andOrder:i];
            CGSize size = [self sizeWithString:[missionModel.auditInfos[i] message] font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT)];
            height = height + 40 +size.height + 10;
            [processView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left).offset(0);
                make.top.equalTo(lineLabel.mas_bottom).offset(10+(40 +size.height + 10)*i);
                make.width.equalTo(SCREEN_WIDTH-20);
                make.height.equalTo(40 + size.height);
            }];
            
            if (missionModel.status == 0) {
                processView.hidden = YES;
            }else {
                processView.hidden = NO;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, lineLabel.frame.origin.y + height + 10);
        });
        if (missionModel.status == 0) {
            progressLabel.hidden = YES;
            lineLabel.hidden = YES;
            
        }else {
            progressLabel.hidden = NO;
            lineLabel.hidden = NO;
            
        }
    }
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
