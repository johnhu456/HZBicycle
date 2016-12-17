//
//  HBNaviManager.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/11/30.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBNaviManager.h"

@interface HBNaviManager()<AMapNaviWalkManagerDelegate,AMapNaviRideManagerDelegate>{
    struct {
        unsigned int finishFlag : 1;
    }_delegateteFlag;
}
@property (nonatomic, strong, readwrite) AMapNaviBaseManager *naviManager;

@end

@implementation HBNaviManager
+ (instancetype)sharedManager {
    static HBNaviManager *_hbNaviManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hbNaviManager = [[HBNaviManager alloc] init];
    });
    return _hbNaviManager;
}

+ (MAPolyline *)getPolylineFromRoutes:(AMapNaviRoute *)route {
    NSInteger count = route.routeCoordinates.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    NSInteger index = 0;
    for (AMapNaviPoint *naviPoint in route.routeCoordinates) {
        commonPolylineCoords[index] = CLLocationCoordinate2DMake(naviPoint.latitude, naviPoint.longitude);
        index ++;
    }
    return [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
}

#pragma mark - Initialize

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
                AMapNaviRideManager *rideManager = (AMapNaviRideManager *)self.naviManager;
                rideManager.delegate = nil;
                rideManager = nil;
                self.naviManager = nil;
                AMapNaviWalkManager *naviWalkManager = [[AMapNaviWalkManager alloc] init];
                naviWalkManager.delegate = self;
                self.naviManager = naviWalkManager;
            }
                break;
            default:
            {
                AMapNaviWalkManager *walkManager = (AMapNaviWalkManager *)self.naviManager;
                walkManager.delegate = nil;
                walkManager = nil;
                self.naviManager = nil;
                AMapNaviRideManager *naviRideManager = [[AMapNaviRideManager alloc] init];
                naviRideManager.delegate = self;
                self.naviManager = naviRideManager;
            }
                break;
        }
    }
}

- (void)setDelegate:(id<HBNaviDelegate>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(finishCalculatedRouteInType:route:error:)]) {
        _delegateteFlag.finishFlag = YES;
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
                AMapNaviRideManager *rideManager = (AMapNaviRideManager *)self.naviManager;
                [rideManager calculateRideRouteWithStartPoint:self.startPoint
                                                                                 endPoint:self.endPoint];
            }
                break;
            default:
                //步行导航
            {
                AMapNaviWalkManager *walkManager = (AMapNaviWalkManager *)self.naviManager;
                [walkManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                                                                 endPoints:@[self.endPoint]];
            }
                break;
        }
    }else {
        _naviType = naviType;
    }
}

- (void)recalculate {
    [self setNaviType:_naviType withRecalculate:YES];
}

#pragma mark - AMapNaviWalkManagerDelegate 
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeWalk route:walkManager.naviRoute error:nil];
    }
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeWalk route:walkManager.naviRoute error:error];
    }
}

-(void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error  {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeWalk route:walkManager.naviRoute error:error];
    }
}

#pragma mark - AMapNaviRideManagerDelegate
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeRide route:rideManager.naviRoute error:nil];
    }
}

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeRide route:rideManager.naviRoute error:error];
    }
}

- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error {
    if (_delegateteFlag.finishFlag) {
        [_delegate finishCalculatedRouteInType:HBNaviTypeRide route:rideManager.naviRoute error:error];
    }
}
@end
