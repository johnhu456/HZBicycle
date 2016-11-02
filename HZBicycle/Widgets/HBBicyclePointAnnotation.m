//
//  HBBicyclePointAnnotation.m
//  HZBicycle
//
//  Created by MADAO on 16/11/2.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicyclePointAnnotation.h"

@interface HBBicyclePointAnnotation()

@property (nonatomic, weak, readwrite) HBBicycleStationModel *station;

@end

@implementation HBBicyclePointAnnotation

- (instancetype)initWithStation:(HBBicycleStationModel *)station {
    if (self = [super init]) {
        self.station = station;
        [self setCoordinate: AMapCoordinateConvert(CLLocationCoordinate2DMake(station.lat, station.lon),AMapCoordinateTypeBaidu)];
    }
    return self;
}
@end
