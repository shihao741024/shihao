//
//  SearchView.m
//  errand
//
//  Created by gravel on 15/12/30.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SearchView.h"
//#import "AttendanceBll.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"

@implementation SearchView{
    int _type;
    int pageIndex;
    NSMutableArray *_dataArray;
    NSString *_staffTele;
    
    NSMutableArray *_modelArray;
}

- (instancetype)initWithFrame:(CGRect)frame andWithType:(int)type{
    if (self = [super initWithFrame:frame]) {
        _selectModelArray = [NSMutableArray array];
        [self createViewAndWithType:type];
        _type = type;
    }
    return self;
}
- (void)createViewAndWithType:(int)type{
    _dataArray = [NSMutableArray array];
    UILabel *startDateLbl = [self createLabelWithFont:18
                                         andTextColor:COMMON_FONT_GRAY_COLOR
                                     andTextAlignment:NSTextAlignmentLeft];
    startDateLbl.frame = CGRectMake(15, 15, 80, 20);
    startDateLbl.text = NSLocalizedString(@"startDate", @"startDate");
    UILabel *startLbl = [self createLabelWithFont:18 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentRight];
    startLbl.frame = CGRectMake(15+100, 0, SCREEN_WIDTH-15 - 100-15, 50);
    _startLbl = startLbl;
    _startLbl.userInteractionEnabled = YES;
    _startLbl.text = @"";
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startLblTap)];
    [_startLbl addGestureRecognizer:tap1];
    
    UILabel *endDateLbl = [self createLabelWithFont:18
                                       andTextColor:COMMON_FONT_GRAY_COLOR
                                   andTextAlignment:NSTextAlignmentLeft];
    endDateLbl.frame = CGRectMake(15, 65, 80, 20);
    endDateLbl.text = NSLocalizedString(@"endDate", @"endDate");
    UILabel *endLbl = [self createLabelWithFont:18 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentRight];
    endLbl.frame = CGRectMake(15+100, 50, SCREEN_WIDTH-15 - 100-15, 50);
    _endLbl = endLbl;
    _endLbl.text = @"";
    _endLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endLblTap)];
    [_endLbl addGestureRecognizer:tap2];
    

    //根据type值不同  创建线
    if (type == 0) {
        for (int i = 0; i < 2; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+20+15+50*i, SCREEN_WIDTH, 0.3)];
            label.tag = 7+i;
            label.backgroundColor = COMMON_FONT_GRAY_COLOR;
            [self addSubview:label];
        }
    }else{
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+20+15+50*i, SCREEN_WIDTH, 0.3)];
            label.tag = 6+i;
            label.backgroundColor = COMMON_FONT_GRAY_COLOR;
            [self addSubview:label];
        }
        UILabel *stafflabel = [self createLabelWithFont:18 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
        stafflabel.frame = CGRectMake(15, 115, 80, 20);
        stafflabel.text = NSLocalizedString(@"chooseStaff", @"chooseStaff");
        UILabel *choiceStaffLbl = [self createLabelWithFont:18 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentRight];
        choiceStaffLbl.frame = CGRectMake(15+100, 100, SCREEN_WIDTH-15 - 100-15, 50);
        _staffLbl = choiceStaffLbl;
        _staffLbl.text = @"";
        _staffLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staffLblTap)];
        [_staffLbl addGestureRecognizer:tap3];
    }
    
//    UILabel *label1 = (UILabel *)[self viewWithTag:7];
    UILabel *label2 = (UILabel *)[self viewWithTag:8];

    AmotButton *setButton = [[AmotButton alloc]init];
    setButton.backgroundColor = [UIColor whiteColor];
    [setButton setTitle:NSLocalizedString(@"reset", @"reset") forState:UIControlStateNormal];
    [setButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    setButton.layer.cornerRadius = 15;
    setButton.layer.borderColor = COMMON_FONT_GRAY_COLOR.CGColor;
    setButton.layer.borderWidth = 0.5;
    [self addSubview:setButton];
    [setButton addTarget:self action:@selector(setButtonClick) forControlEvents:UIControlEventTouchUpInside];
    AmotButton *sureButton = [[AmotButton alloc]init];
    sureButton.backgroundColor = COMMON_BLUE_COLOR;
    [sureButton setTitle:NSLocalizedString(@"sure", @"sure") forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 15;
    [self addSubview:sureButton];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.height.equalTo(30);
        make.width.equalTo(100);
        make.left.equalTo(SCREEN_WIDTH/2-15-100);
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.height.equalTo(30);
        make.width.equalTo(100);
        make.right.equalTo(-(SCREEN_WIDTH/2-15-100));
    }];
}

- (void)startLblTap{
    MMDateView *dateView = [MMDateView new];
    [dateView.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    dateView.delegate=self;
    dateView.centerLabel.text = @"开始日期";
    dateView.datePicker.tag=1;
    [dateView showWithBlock:nil];

}
- (void)endLblTap{
    MMDateView *dateView = [MMDateView new];
    dateView.delegate=self;
    dateView.centerLabel.text = @"结束日期";
    dateView.datePicker.tag=2;
    [dateView showWithBlock:nil];
}

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:picker.date];
    if (picker.tag == 1) {
        _startLbl.text = strDate;
    }else{
        _endLbl.text = strDate;
    }
    
   
}
- (void)buttonClick:(UIButton *)button{
    for (int i = 10; i < 13; i ++) {
        if (i == button.tag) {
            button.backgroundColor = COMMON_BLUE_COLOR;
            button.selected = YES;
        }else{
             UIButton *button = (UIButton *)[self viewWithTag:i];
             button.backgroundColor = COMMON_FONT_GRAY_COLOR;
            button.selected = NO;
        }
    }
}
- (void)setButtonClick{
    _startLbl.text = @"";
    _endLbl.text = @"";
    if (_type == 1 ) {
        _staffLbl.text = @"";
    }
    [_selectModelArray removeAllObjects];
}


#pragma mark --- 确定按钮点击
- (void)sureButtonClick{
    //获取数据
    if ((_type == 1)&& (_staffLbl.text.length == 0)) {
         [Dialog simpleToast:@"不能有空信息"];
    }else if ([_startLbl.text isEqualToString:@""]||[_endLbl.text isEqualToString:@""]) {
          [Dialog simpleToast:@"不能有空信息"];
    }else{
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *startDate = [dateformatter dateFromString:_startLbl.text];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startStr = [dateFormatter2 stringFromDate:startDate];
        NSDate *endDate = [dateformatter dateFromString:_endLbl.text];
         NSString *endStr = [dateFormatter2 stringFromDate:endDate];
        if ([_startLbl.text compare:_endLbl.text] == 1 ) {
            [Dialog simpleToast:@"开始日期不能大于结束日期"];
            }else{
                if (_type == 0) {
                    self.recordBlock(startStr,endStr,@"",YES);
                }else{
//                    self.recordBlock(startStr,endStr,_staffTele,YES);
                    [_selectModelArray removeAllObjects];
                    [_selectModelArray addObjectsFromArray:_modelArray];
                    
                    self.recordModelBlock(startStr,endStr,_modelArray);
                }
            }
       
    }
 }

//封装的标签
-(UILabel *)createLabelWithFont:(float)size
                   andTextColor:(UIColor *)color
               andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [self addSubview:label];
    return label;
}

#pragma mark ---- Staffinfo
- (void)staffLblTap{
//    SelectStaffView* staffView = [[SelectStaffView alloc]init];
//    staffView.delegate = self;
//    [self addSubview:staffView];
    
    UIViewController *currentCtrl = [Function getViewControllerWithView:self];
    
    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
    vc.type = 2;
    vc.subordinateLayout = YES;
    vc.staffModelArray = _selectModelArray;
    
    [currentCtrl.navigationController pushViewController:vc animated:YES];
    
    [vc setSelectstaffArrayBlock:^(NSMutableArray *array) {
        _modelArray = array;
        
        [_selectModelArray removeAllObjects];
        [_selectModelArray addObjectsFromArray:_modelArray];
        
        NSMutableArray *nameArray= [NSMutableArray array];
        for (StaffModel *model in array) {
            [nameArray addObject:model.staffName];
        }
        _staffLbl.text = [nameArray componentsJoinedByString:@" "];
    }];
    
}
- (void)selectStaffWithName:(NSString *)name andTelephone:(NSString *)telephone andID:(NSNumber *)id{
        _staffLbl.text = name;
        _staffTele = telephone;
}

- (void)selectStaffWithInfo:(StaffInfoModel *)model
{
    _staffLbl.text = model.staffInfoName;
}

@end
