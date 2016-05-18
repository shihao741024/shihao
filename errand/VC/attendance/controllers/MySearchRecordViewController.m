//
//  MySearchRecordViewController.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MySearchRecordViewController.h"
#import "AttendanceBll.h"

@interface MySearchRecordViewController ()
{
    
}
@end

//继承RecordViewController，展示搜素结果
@implementation MySearchRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
   
   [self showHintInView:self.view];
    AttendanceBll *attendanBll = [[AttendanceBll alloc]init];
    [attendanBll getRealSearchRecordData:^(NSArray *array) {
        [self.dataArray removeAllObjects];
        
        MyRecordModel *modelOne = [[self.dataArray lastObject] lastObject];
        MyRecordModel *modelTwo = [[array firstObject] firstObject];
        
        if ([modelTwo.flagTimeStr isEqualToString:modelOne.flagTimeStr]) {
            
            NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[self.dataArray lastObject]];
            [itemArray addObjectsFromArray:[array firstObject]];
            [self.dataArray removeLastObject];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
            [tempArray removeObjectAtIndex:0];
            
            [self.dataArray addObject:itemArray];
            [self.dataArray addObjectsFromArray:tempArray];
            
        } else {
            
            [self.dataArray addObjectsFromArray:array];
        }
        
        [self.tableView reloadData];
        [self hideHud];
        [self.slimeView endRefresh];
        [self.tableView footerEndRefreshing];
        [self hideInfica];
    } type:self.type pageIndex:1 startDate:_passStartDate endDate:_passEndDate staffStr:@"" viewCtrl:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [MyAdapter aDapterView:40];
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, [MyAdapter aDapterView:40])];
    label.backgroundColor = COMMON_BACK_COLOR;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[[self.dataArray[section] lastObject] flagTimeStr]];
    NSString *weekStr = [self weekdayStringFromDate:date];
    //    NSDateFormatter *dateFormatter1 = [[NSDateFormatter  alloc]init];
    //    [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
    //    NSString *dateStr = [dateFormatter1 stringFromDate:date];
    
    label.text = [NSString stringWithFormat:@"%@%@%@",[[self.dataArray[section] lastObject] flagTimeStr],@"  ",weekStr];
    //    label.text = [[_dataArray[section] lastObject] flagTimeStr];
    label.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COMMON_FONT_BLACK_COLOR;
    return label;
}

- (void)createRightItem{
}

- (void)createDateChangeView
{
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
