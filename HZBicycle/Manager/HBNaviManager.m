//
//  HBNaviManager.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/11/30.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBNaviManager.h"

@interface HBNaviManager()<AMapNaviWalkManagerDelegate,AMapNaviRideManagerDelegate>

@property (nonatomic, strong, readwrite) AMapNaviBaseManager *naviManager;

@end

@implementation HBNaviManager

#pragma mark - Initialize

+ (instancetype)sharedManager {
    static HBNaviManager *_hbNaviManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hbNaviManager = [[HBNaviManager alloc] init];
    });
    return _hbNaviManager;
}

- (instancetype)init {
    if (self = [super init]) {
        //保证第一次进入setter不会直接return
        _naviType = -1;
    }
    return self;
}

#pragma mark - Setter
- (void)setNaviType:(HBNaviType)naviType {
    if (_naviType == naviType)
        //不变更 _naviManager
        return;
    else {
        _naviType = naviType;
        switch (_naviType) {
            case HBNaviTypeWalk:
            {
                _naviManager = nil;
                AMapNaviWalkManager *naviWalkManager = [[AMapNaviWalkManager alloc] init];
                naviWalkManager.delegate = self;
                _naviManager = naviWalkManager;
            }
                break;
            default:
            {
                _naviManager = nil;
                AMapNaviRideManager *naviRideManager = [[AMapNaviRideManager alloc] init];
                naviRideManager.delegate = self;
                _naviManager = naviRideManager;
            }
                break;
        }
    }
}

#pragma mark - Public Method
- (void)getRouteWithStartCoordinate:(CLLocationCoordinate2D)start
                      endCoordinate:(CLLocationCoordinate2D)end
                           naviType:(HBNaviType)type {
    self.startPoint = [AMapNaviPoint locationWithLatitude:start.latitude longitude:start.longitude];
    self.endPoint = [AMapNaviPoint locationWithLatitude:end.latitude longitude:end.longitude];
    [self setNaviType:type withRecalculate:YES];
}

- (void)setNaviType:(HBNaviType)naviType
    withRecalculate:(BOOL)recalculate {
    if (recalculate) {
        if (self.startPoint == nil || self.endPoint == nil) {
            [[NSException exceptionWithName:@"Undefine navi points" reason:@"Set navi start point and end point firstly before caclucate routes" userInfo:nil] raise];
        }
        self.naviType = naviType;
        switch (naviType) {
            case HBNaviTypeRide:
                //骑行导航
            {
                [(AMapNaviRideManager *)self.naviManager calculateRideRouteWithStartPoint:self.startPoint
                                                                                 endPoint:self.endPoint];
            }
                break;
            default:
                //步行导航
            {
                [(AMapNaviWalkManager *)self.naviManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                                                                 endPoints:@[self.endPoint]];
            }
                break;
        }
    }
}

#pragma mark - AMapNaviWalkManagerDelegate 
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    NSLog(@"%@",walkManager.naviRoute);
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error  {
    NSLog(@"%@",error);
}

#pragma mark - AMapNaviRideManagerDelegate
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    NSLog(@"%@",rideManager.naviRoute);
}

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"%@",error);
}
@end
