//
//  DistriTableView.m
//  errand
//
//  Created by gravel on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DistriTableView.h"
#import "DistriModel.h"
@implementation DistriTableView{
    NSMutableArray *_distriArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style distriArray:(NSMutableArray*)distriArray{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        _distriArray = [NSMutableArray arrayWithArray:distriArray];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _distriArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    DistriModel *model = _distriArray[indexPath.row];
    cell.textLabel.text = model.vendor;
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.distriDelegate respondsToSelector:@selector(cellClick:)]) {
        DistriModel *model = _distriArray[indexPath.row];
        [self.distriDelegate cellClick:model.vendor];
    }
}

- (void)tableviewReloadWithArray:(NSArray *)array{
    _distriArray = [NSMutableArray arrayWithArray:array];
    [self reloadData];
}
@end
