//
//  HBBicycleResultModel.h
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleBaseModel.h"

/**查询结果Model*/
@interface HBBicycleResultModel : HBBicycleBaseModel

@property (nonatomic, assign) NSUInteger count;

/**服务点数据*/
@property (nonatomic, strong) NSArray *data;

@end
