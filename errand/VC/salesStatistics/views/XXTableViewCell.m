//
//  XXTableViewCell.m
//  test
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 xuxiang. All rights reserved.
//

#import "XXTableViewCell.h"
#import "SalesStatisticsBll.h"
@implementation XXTableViewCell {
   
    UIView       *_bgView;
    float         _startOffsetX;
    float         _endOffsetX;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTag:(NSInteger)tag {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.tag = tag;
        self.flag = 0;
        [self createBackgroundOfCell];
    }
    return self;
}

- (void)createBackgroundOfCell {
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    _bgScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width+90, 150);
    _bgScrollView.bounces = NO;
    _bgScrollView.userInteractionEnabled = YES;
    _bgScrollView.delegate= self;
    _bgScrollView.backgroundColor = COMMON_BACK_COLOR;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_bgScrollView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 150 - 10)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    [_bgScrollView addSubview:_bgView];
    
    UIView *pointView = [[UIView alloc]init];
    pointView.size = CGSizeMake(5, 5);
    pointView.layer.cornerRadius = 2.5;
    pointView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:pointView];
    pointView.hidden = YES;
    
    UIView *pointView2  = [[UIView alloc]init];
    pointView2.size = CGSizeMake(5, 5);
    pointView2.layer.cornerRadius = 2.5;
    pointView2.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:pointView2];
    pointView2.hidden = YES;
    
    
    self.stateLabel = [self createLabelWithFont:15 andTextColor:[UIColor whiteColor] andTextAlignment:NSTextAlignmentCenter];
    
    self.taskNameLabel = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.startDate = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight];
    self.phoneNumber = [self createLabelWithFont:21 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.receiveName = [self createLabelWithFont:21 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.endDate = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.remarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];

   
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startDate.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(@20);
    }];
    
    [self.startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(@140);
        make.height.equalTo(@25);
    }];
    
    [self.receiveName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.phoneNumber.mas_right).offset(3);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
        
    }];
    
    [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(@20);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endDate.mas_bottom).offset(5);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(@20);
    }];
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(5+8);
        make.left.equalTo(_bgView.mas_left).offset(20);
        make.width.equalTo(@5);
        make.height.equalTo(@5);
    }];
    
    [pointView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endDate.mas_bottom).offset(5+8);
        make.left.equalTo(_bgView.mas_left).offset(20);
        make.width.equalTo(@5);
        make.height.equalTo(@5);
    }];
 
    
    
    AmotButton *deleteBtn = [[AmotButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH + 15 ,20, 50, 50)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    deleteBtn.backgroundColor = [UIColor blueColor];
//    deleteBtn.layer.cornerRadius = (_bgScrollView.frame.size.height/2-15)/2;
//    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:deleteBtn];
    
    AmotButton *editBtn = [[AmotButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH + 15 , 10+80, 50, 50)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
//    editBtn.backgroundColor = [UIColor yellowColor];
//    editBtn.layer.cornerRadius = (_bgScrollView.frame.size.height/2-15)/2;
//    editBtn.layer.masksToBounds = YES;
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:editBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    // 点击被要求次数, 单击或者双击
    tap.numberOfTapsRequired = 1;
    // 添加一个手势到某个视图上
    [_bgScrollView addGestureRecognizer:tap];
}

-(void)setSalesStatisticsModel:(SalesStatisticsModel *)model andType:(int)type{
    self.stateLabel.textColor = [UIColor grayColor];
    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    self.stateLabel.backgroundColor = [UIColor whiteColor];
    self.stateLabel.text = model.dateString;
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(30);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        
    }];
    
    self.startDate.text = @"";
    self.taskNameLabel.text = model.pillName;
    self.taskNameLabel.textColor = COMMON_BLUE_COLOR;
    self.taskNameLabel.font = GDBFont(18);
    
    NSString *sizeStr = model.amountString;
    if (![Function isBlankStrOrNull:model.packageUnit]) {
        sizeStr = [sizeStr stringByAppendingFormat:@" / %@", model.packageUnit];
    }
    if (![Function isNullOrNil:model.price]) {
        float priceFloat = [model.price floatValue];
        sizeStr = [sizeStr stringByAppendingFormat:@"  %.2f元", priceFloat];
    }else {
        
    }
    
    self.phoneNumber.text = sizeStr;
    self.phoneNumber.font = GDBFont(15);
    
    self.receiveName.text = @"";
    
    
    if (type == 0) {
        self.endDate.text = model.hospitalName;
    }else {
        self.endDate.text = [NSString stringWithFormat:@"%@ / %@", model.name, model.hospitalName];
    }
    
    if (type == 1) {
//         self.remarkLabel.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.office];
        self.remarkLabel.text = @"";
    }else{
        self.remarkLabel.text = model.buyerString;

    }
    self.phoneImageLabel.text = @"";
    self.salesStatisticsID = model.salesStatisticsID;
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
//    NSLog(@"手势  %lu", self.tag);
    if ([self.delegateOfXXTableView respondsToSelector:@selector(clickCellWithIndex:)]) {
        [self.delegateOfXXTableView clickCellWithIndex:self.tag];
    }
}

- (void)deleteBtnClick {
    //首先获得Cell：button的父视图是contentView，再上一层才是UITableViewCell
//    XXTableViewCell *cell = (XXTableViewCell *)button.superview.superview; 	//然后使用indexPathForCell方法，就得到indexPath了~
  
    self.deleteBtnClickBlock(self.salesStatisticsID, self);

}

- (void)editBtnClick {
    self.editBtnClickBlock(self.salesStatisticsID, self);
}

//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [_bgView addSubview:label];
    return label;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"视图将要开始滚动!");
//    NSLog(@"begin%f", scrollView.contentOffset.x);
    _startOffsetX = scrollView.contentOffset.x;
    if ([self.delegateOfXXTableView respondsToSelector:@selector(isScrollViewInCellMove: andIndex:)]) {
        [self.delegateOfXXTableView isScrollViewInCellMove:YES andIndex:self.tag];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    NSLog(@"%d %f", decelerate, scrollView.contentOffset.x);
    if (!decelerate) {
        float differenceX = scrollView.contentOffset.x - _startOffsetX;
        if (differenceX >= 0 && (differenceX < 30)) {
            
            [UIView animateWithDuration:0.1 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
                
            }];
        } else if (differenceX < 0 ) {
            
            [UIView animateWithDuration:0.1 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
                
            }];
        } else if (differenceX >= 30){
            self.flag = 1;
            if ([self.delegateOfXXTableView respondsToSelector:@selector(isScrollViewInCellMove: andIndex:)]) {
                [self.delegateOfXXTableView isScrollViewInCellMove:YES andIndex:self.tag];
            }
            [UIView animateWithDuration:0.1 animations:^{
                scrollView.contentOffset = CGPointMake(90, 0);
                
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"视图jieshu滚动!");
//    NSLog(@"%f", scrollView.contentOffset.x);
    _endOffsetX = scrollView.contentOffset.x;
    float differenceX = _endOffsetX - _startOffsetX;
    if (differenceX >= 30) {
        
        self.flag = 1;
        if ([self.delegateOfXXTableView respondsToSelector:@selector(isScrollViewInCellMove: andIndex:)]) {
            [self.delegateOfXXTableView isScrollViewInCellMove:YES andIndex:self.tag];
        }
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(90, 0);
            
        }];
        return;
    }
    if (_endOffsetX - _startOffsetX < 30 && differenceX >=0) {
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            self.flag = 0;
        }];
        return;
    }
    if (differenceX <= -30) {
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            self.flag = 0;
        }];
        return;
    }
    if (differenceX < 0 && differenceX > -30) {
        
        self.flag = 1;
        if ([self.delegateOfXXTableView respondsToSelector:@selector(isScrollViewInCellMove: andIndex:)]) {
            [self.delegateOfXXTableView isScrollViewInCellMove:YES andIndex:self.tag];
        }
        [UIView animateWithDuration:0.1 animations:^{
            scrollView.contentOffset = CGPointMake(90, 0);
            
        }];
        return;
    }
    
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    
//    NSLog(@"xxxxxx%f", scrollView.contentOffset.x);
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
