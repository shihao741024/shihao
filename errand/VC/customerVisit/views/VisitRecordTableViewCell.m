//
//  VisitRecordTableViewCell.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitRecordTableViewCell.h"

@implementation VisitRecordTableViewCell
{
    UIView *_bgView;
    UIImageView *_statusImg;
    UILabel *_timeLabel;
    
    UILabel *_nameLabel;
    UILabel *_visitTypeLabel;
    UILabel *_visitPeople;
    
    UILabel *_carryPeople;
    UILabel *_visitConclusion;
    UILabel *_conclusionText;
    
    UIView *_lineView;
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

- (void)uiConfig
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, kWidth-20, 0)];
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _bgView.layer.cornerRadius = 10;
    [self.contentView addSubview:_bgView];
    
    _statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 16)];
    [_bgView addSubview:_statusImg];
    
    _timeLabel = [_bgView createGeneralLabel:14 frame:CGRectMake(kFrameW(_bgView)-10-175, 10, 175, 16) textColor:COMMON_FONT_GRAY_COLOR];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _visitTypeLabel = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameW(_bgView)-10-60, kFrameY(_statusImg)+kFrameH(_statusImg)+10, 60, 20) textColor:kGreenColor];
    
    _nameLabel = [_bgView createGeneralLabel:17 frame:CGRectMake(30, kFrameY(_visitTypeLabel), kFrameW(_bgView)-30-kFrameW(_visitTypeLabel), kFrameH(_visitTypeLabel)) textColor:COMMON_FONT_BLACK_COLOR];
    
    _visitPeople = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, kFrameW(_bgView)-30, 17) textColor:COMMON_FONT_BLACK_COLOR];
    
    _carryPeople = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_visitPeople), kFrameY(_visitPeople)+kFrameH(_visitPeople)+10, kFrameW(_bgView)-30, 17) textColor:COMMON_FONT_BLACK_COLOR];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameY(_carryPeople)+kFrameH(_carryPeople)+10, kFrameW(_bgView), 0.5)];
    _lineView.backgroundColor = GDBColorRGB(0.87, 0.87, 0.87, 1);
    [_bgView addSubview:_lineView];
    
    _visitConclusion = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_carryPeople), kFrameY(_lineView)+kFrameH(_lineView)+10, kFrameW(_bgView)-30, 17) textColor:COMMON_FONT_GRAY_COLOR];
    _visitConclusion.text = @"拜访总结";
    
    _conclusionText = [_bgView createGeneralLabel:15 frame:CGRectMake(kFrameX(_visitConclusion), kFrameY(_visitConclusion)+kFrameH(_visitConclusion)+10, kFrameW(_bgView)-30, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _conclusionText.numberOfLines = 0;
    
}

- (void)fillData:(NSDictionary *)dic
{
    _statusImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"visitStatus%@", dic[@"status"]]];
    _timeLabel.text = dic[@"visitDate"];
    
    if ([dic[@"category"] isEqual:@0]) {
        _visitTypeLabel.textColor = kGreenColor;
        _visitTypeLabel.text = @"计划拜访";
    }else {
        _visitTypeLabel.text = @"临时拜访";
        _visitTypeLabel.textColor = kOrangeColor;
    }
    
    _nameLabel.text = dic[@"doctor"][@"name"];
    
    NSString *visitPeopleStr = [NSString stringWithFormat:@"拜访人：  %@", dic[@"belongTo"][@"name"]];
    NSMutableAttributedString *visitPeopleAttrStr = [[NSMutableAttributedString alloc] initWithString:visitPeopleStr];
    [visitPeopleAttrStr setAttributes:@{NSForegroundColorAttributeName: COMMON_FONT_GRAY_COLOR} range:[visitPeopleStr rangeOfString:@"拜访人："]];
    _visitPeople.attributedText = visitPeopleAttrStr;
    
    NSString *carryPeopleStr;
    if (dic[@"assist"] == [NSNull null]) {
        carryPeopleStr = [NSString stringWithFormat:@"携访人：  %@", @"无"];
    }else {
        carryPeopleStr = [NSString stringWithFormat:@"携访人：  %@", dic[@"assist"][@"name"]];
    }
    
    NSMutableAttributedString *carryPeopleAttrStr = [[NSMutableAttributedString alloc] initWithString:carryPeopleStr];
    [carryPeopleAttrStr setAttributes:@{NSForegroundColorAttributeName: COMMON_FONT_GRAY_COLOR} range:[carryPeopleStr rangeOfString:@"携访人："]];
    _carryPeople.attributedText = carryPeopleAttrStr;
    
    
    if (dic[@"summary"] == [NSNull null]) {
        _lineView.hidden = YES;
        _visitConclusion.hidden = YES;
        _conclusionText.hidden = YES;
        
        _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), kFrameY(_carryPeople)+kFrameH(_carryPeople)+10);
        
    }else {
        
        _lineView.hidden = NO;
        _visitConclusion.hidden = NO;
        _conclusionText.hidden = NO;
        
        _conclusionText.text = dic[@"summary"];
        CGSize size = [Function sizeOfStr:dic[@"summary"] andFont:_conclusionText.font andMaxSize:CGSizeMake(kFrameW(_conclusionText), CGFLOAT_MAX)];
        _conclusionText.frame = CGRectMake(kFrameX(_conclusionText), kFrameY(_conclusionText), kFrameW(_conclusionText), size.height);
        
        _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), kFrameY(_conclusionText)+kFrameH(_conclusionText)+10);
    }
    
    self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameH(_bgView)+10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
