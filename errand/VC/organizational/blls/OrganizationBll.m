//
//  OrganizationBll.m
//  errand
//
//  Created by gravel on 15/12/12.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "OrganizationBll.h"
#import "StaffModel.h"
#import "TreeStaffModel.h"
#import "Node.h"
@implementation OrganizationBll

- (void)getFirstOrgnizationData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{

    
    NSString *strUrl=@"/api/v1/org/tree";
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSString *str = [responseObject mj_JSONString];
//              NSLog(@"%@",str);
        
        // 根节点model
        Node *model = [[Node alloc] init];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[model nodesArrayWithTreeDic:responseObject]];
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
         NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getAboutSalesData:(void (^)(NSArray *arr))successArr salesId:(NSNumber*)salesId viewCtrl:(id)viewCtrl{
    NSString *strUrl = [NSString stringWithFormat: @"/api/v1/org/%@/sales",salesId];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
//            TreeStaffModel *model = [[TreeStaffModel alloc]initWithDic:dic];
            
            Node *model = [[Node alloc] init];
            model.expand = NO;
            model.hasRequest = NO;
            model.nodeId = [dic[@"id"] intValue];
            model.parentId = [salesId intValue];
            model.name = dic[@"name"];
            model.hasChildrenNode = NO;
            model.quantity = dic[@"organization"][@"quantity"];
            
            //
            model.telephone = dic[@"telephone"];
            model.department = dic[@"organization"][@"name"];
            model.avatar = dic[@"avatar"];
            model.weixin = dic[@"weixin"];
            model.email = dic[@"email"];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getSecondOrgnizationData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSString *urlStr = @"/api/v1/sales";
    [self  get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSString *str = [responseObject mj_JSONString];
//    NSLog(@"%@",str);
        NSMutableArray *dataArray = [NSMutableArray array];
        
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            StaffModel *model = [[StaffModel alloc]initWithDic:dic];
            [sourceArray addObject:model];
        }
        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                StaffModel *model = sourceArray[k];
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                    [itemArray addObject:model];
                }
            }
            //            if (itemArray.count > 0) {
            [dataArray addObject:itemArray];
            //            }
            
        }
        //首字母不是26个字母的
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
        for (int j = 0 ; j < sourceArray.count; j++) {
            StaffModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (StaffModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        successArr([dataArray copy]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getMyTreeData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSString *urlStr = @"/api/v1/org/myTree";
    [self get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSString *str = [responseObject mj_JSONString];
        //        NSLog(@"%@",str);
        // 根节点model
        Node *model = [[Node alloc] init];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[model nodesArrayWithTreeDic:responseObject]];
        
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

@end

