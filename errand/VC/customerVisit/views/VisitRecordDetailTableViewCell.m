//
//  VisitRecordDetailTableViewCell.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitRecordDetailTableViewCell.h"
#import "DoctorDetailShowViewController.h"


@implementation VisitRecordDetailTableViewCell
{
    CornerBgView *_bgView;
    UIImageView *_statusImg;
    UILabel *_timeLabel;
    
    UILabel *_nameLabel;
    UILabel *_visitTypeLabel;
    
    
    UILabel *_visitPeopleTitle;
    UILabel *_visitPeople;
    
    UILabel *_arriveTitle;
    UILabel *_arrive;
    
    UILabel *_leaveTitle;
    UILabel *_leave;
    
    UILabel *_carryPeopleTitle;
    UILabel *_carryPeople;
    
    UILabel *_hospitalTitle;
    UILabel *_hospital;
    
    UILabel *_productTitle;
    UILabel *_product;
    
    NSNumber *_doctorId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
        [self uiConfig];
    }
    return self;
}

CGFloat titleW = 80;
CGFloat titleSpace = 10;

- (void)uiConfig
{
    _bgView = [[CornerBgView alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 50) cornerStyle:CornerNone cornerRadius:10];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 16)];
    [_bgView addSubview:_statusImg];
    
    _timeLabel = [_bgView createGeneralLabel:14 frame:CGRectMake(kFrameW(_bgView)-10-175, 10, 175, 16) textColor:COMMON_FONT_GRAY_COLOR];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _visitTypeLabel = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameW(_bgView)-10-60, kFrameY(_statusImg)+kFrameH(_statusImg)+10, 60, 20) textColor:kGreenColor];
    
    _nameLabel = [_bgView createGeneralLabel:17 frame:CGRectMake(30, kFrameY(_visitTypeLabel), kFrameW(_bgView)-30-kFrameW(_visitTypeLabel), kFrameH(_visitTypeLabel)) textColor:COMMON_FONT_BLACK_COLOR];
    
   
    
    _visitPeopleTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _visitPeopleTitle.text = @"拜访人：";
    
    _visitPeople = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_visitPeopleTitle), kFrameW(_bgView)-titleSpace-titleW, 17) textColor:COMMON_FONT_BLACK_COLOR];
    
    
    
    _arriveTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_visitPeople)+kFrameH(_visitPeople)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _arriveTitle.text = @"拜访签到：";
    
    _arrive = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_arriveTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _arrive.numberOfLines = 0;
    
    
    
    _leaveTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_arrive)+kFrameH(_arrive)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _leaveTitle.text = @"拜访离开：";
    
    _leave = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_leaveTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _leave.numberOfLines = 0;
    
    
    
    _carryPeopleTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_leave)+kFrameH(_leave)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _carryPeopleTitle.text = @"协访人：";
    
    _carryPeople = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_carryPeopleTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _carryPeople.numberOfLines = 0;
    
    
    
    _hospitalTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_carryPeople)+kFrameH(_carryPeople)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    
    _hospitalTitle.text = @"医院：";
    
    _hospital = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_hospitalTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _hospital.numberOfLines = 0;
    
    _productTitle = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_hospital)+kFrameH(_hospital)+10, titleW, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _productTitle.text = @"产品：";
    
    _product = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_productTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _product.numberOfLines = 0;
    
}

- (void)fillData:(NSDictionary *)dic cornerStyle:(CornerStyle)cornerStyle
{
    _statusImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"visitStatus%@", dic[@"status"]]];
    _timeLabel.text = dic[@"visitDate"];
    _doctorId = dic[@"doctor"][@"id"];
    
    if ([dic[@"category"] isEqual:@0]) {
        _visitTypeLabel.textColor = kGreenColor;
        _visitTypeLabel.text = @"计划拜访";
    }else {
        _visitTypeLabel.text = @"临时拜访";
        _visitTypeLabel.textColor = kOrangeColor;
    }
    
    _nameLabel.text = dic[@"doctor"][@"name"];
    _visitPeople.text = dic[@"belongTo"][@"name"];
    
    
    /*====================*/
    NSString *nameStr = _nameLabel.text;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    NSRange detailRange = [nameStr rangeOfString:_nameLabel.text];
    [attri addAttribute:NSLinkAttributeName value:@(NSUnderlineStyleSingle) range:detailRange];
    [attri addAttribute:NSFontAttributeName value:GDBFont(17) range:NSMakeRange(0, nameStr.length)];
    
//    NSUInteger length = [nameStr length];
//    [attri addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:COMMON_FONT_BLACK_COLOR range:NSMakeRange(0, length)];
    [_nameLabel setAttributedText:attri];
    
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLableClick)];
    [_nameLabel addGestureRecognizer:tapGesture];
    //[UIColor colorWithRed:0.8086 green:0.8086 blue:0.8086 alpha:1.0]  更改成蓝色 COMMON_FONT_BLACK_COLOR
    /*====================*/
    
    
    if ([Function isNullOrNil:dic[@"arrive"]]) {
        _arriveTitle.hidden = YES;
        _arrive.hidden = YES;
        _leaveTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_arriveTitle), titleW, 17);
        
    }else {
        _arriveTitle.hidden = NO;
        _arrive.hidden = NO;
        
        NSString *arriveStr = [NSString stringWithFormat:@"%@\n%@", [self getTimeStr:dic[@"arriveDate"]], dic[@"arrive"][@"name"]];
        CGSize arriveSize = [Function sizeOfStr:arriveStr andFont:GDBFont(15) andMaxSize:CGSizeMake(kFrameW(_arrive), CGFLOAT_MAX)];
        _arrive.text = arriveStr;
        _arrive.frame = CGRectMake(kFrameX(_arrive), kFrameY(_arrive), kFrameW(_arrive), arriveSize.height);
        
        _leaveTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_arrive)+kFrameH(_arrive)+10, titleW, 17);
    }
    
    if ([Function isNullOrNil:dic[@"leave"]]) {
        _leaveTitle.hidden = YES;
        _leave.hidden = YES;
        _carryPeopleTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_leaveTitle), titleW, 17);
    }else {
        _leaveTitle.hidden = NO;
        _leave.hidden = NO;
        
        NSString *leaveStr = [NSString stringWithFormat:@"%@\n%@", [self getTimeStr:dic[@"leaveDate"]], dic[@"leave"][@"name"]];
        CGSize leaveSize = [Function sizeOfStr:leaveStr andFont:GDBFont(15) andMaxSize:CGSizeMake(kFrameW(_leave), CGFLOAT_MAX)];
        _leave.text = leaveStr;
        _leave.frame = CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_leaveTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, leaveSize.height);
        
        _carryPeopleTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_leave)+kFrameH(_leave)+10, titleW, 17);
    }
    
    if ([Function isNullOrNil:dic[@"assist"]]) {
        _carryPeopleTitle.hidden = YES;
        _carryPeople.hidden = YES;
        _hospitalTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_carryPeopleTitle), titleW, 17);
    }else {
        _carryPeopleTitle.hidden = NO;
        _carryPeople.hidden = NO;
        
        _carryPeople.text = dic[@"assist"][@"name"];
        _carryPeople.frame = CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_carryPeopleTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, 17);
        
        _hospitalTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_carryPeopleTitle)+kFrameH(_carryPeopleTitle)+10, titleW, 17);
    }
    
    _hospital.text = dic[@"hospital"][@"name"];
    CGSize hospitalSzie = [Function sizeOfStr:_hospital.text andFont:GDBFont(15) andMaxSize:CGSizeMake(kFrameW(_hospital), CGFLOAT_MAX)];
    _hospital.frame = CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_hospitalTitle), kFrameW(_bgView)-kFrameX(_nameLabel)-titleSpace-titleW-5, hospitalSzie.height);
    
    _productTitle.frame = CGRectMake(kFrameX(_nameLabel), kFrameY(_hospital)+kFrameH(_hospital)+10, titleW, 17);
    
    _product.text = [NSString stringWithFormat:@"%@(%@)", dic[@"production"][@"name"], dic[@"production"][@"specification"]];
    CGSize productSzie = [Function sizeOfStr:_product.text andFont:GDBFont(15) andMaxSize:CGSizeMake(kFrameW(_product), CGFLOAT_MAX)];
    _product.frame = CGRectMake(kFrameX(_nameLabel)+titleSpace+titleW, kFrameY(_productTitle), kFrameW(_product), productSzie.height);
    
    _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), kFrameY(_product)+kFrameH(_product)+10);
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameH(_bgView)-1);
    //加1防止上下cell线条不重合，导致变粗
    
    [_bgView handleSetNeedsLayoutWithStyle:cornerStyle];
}

- (NSString *)getTimeStr:(id)timetamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timetamp floatValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    
    return [formatter stringFromDate:date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)nameLableClick{
    _doctorNameLableClick(_doctorId);
}

@end
