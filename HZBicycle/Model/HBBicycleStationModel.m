//
//  HBBicycleStationModel.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleStationModel.h"

@implementation HBBicycleStationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"stationID": @"id"
             };
}
@end
