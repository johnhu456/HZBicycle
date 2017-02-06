//
//  HBBicycleResultModel.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleResultModel.h"

@implementation HBBicycleResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data":[HBBicycleStationModel class],
             };
}

- (HBBicycleStationModel *)nearestRentableStation {
    HBBicycleStationModel *resultStation;
    for (HBBicycleStationModel *station in self.data) {
        if (station.rentcount > 0) {
            resultStation = station;
            break;
        }
    }
    return resultStation;
}

- (HBBicycleStationModel *)nearestRestoreableStation {
    HBBicycleStationModel *resultStation;
    for (HBBicycleStationModel *station in self.data) {
        if (station.restorecount > 0) {
            resultStation = station;
            break;
        }
    }
    return resultStation;
}
@end
