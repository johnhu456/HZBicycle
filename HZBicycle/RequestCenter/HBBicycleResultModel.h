//
//  HBBicycleResultModel.h
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleBaseModel.h"
#import "HBBicycleStationModel.h"

/**查询结果Model*/
@interface HBBicycleResultModel : HBBicycleBaseModel

@property (nonatomic, assign) NSUInteger count;

/**服务点数据*/
@property (nonatomic, strong) NSArray *data;

/**
 获取最近可租的自行车站点

 @return 具体站点
 */
- (HBBicycleStationModel *)nearestRentableStation;


/**
 获取最近可换的自行车站点

 @return 具体站点
 */
- (HBBicycleStationModel *)nearestRestoreableStation;

@end
