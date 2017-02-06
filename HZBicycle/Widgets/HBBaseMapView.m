//
//  HBBaseMapView.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/6.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBaseMapView.h"

@interface HBBaseMapView()

@property (nonatomic, weak) HBBicycleResultModel *stationResult;

@end

#pragma mark - Constant
static CGFloat const kMapZoomLevel = 15;

@implementation HBBaseMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self  = [super initWithFrame:frame]) {
        [self setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
        self.desiredAccuracy = kCLLocationAccuracyBest;
        self.zoomLevel = 15;
        //无法调整角度
        self.rotateCameraEnabled = NO;
    }
    return self;
}
- (void)addBicycleStations:(HBBicycleResultModel *)stations
                 withIndex:(NSUInteger)index
                  animated:(BOOL)animated{
    [self removeAnnotations:self.annotations];
    self.stationResult = stations;
    for (HBBicycleStationModel *model in self.stationResult.data) {
        [self addAnnotationWithStation:model];
    }
    //设最近的或者选中的为中心点
    if (self.stationResult.data[index]) {
        HBBicyclePointAnnotation *annotation = self.annotations[index];
        [self setCenterCoordinate:annotation.coordinate animated:animated];
        [self selectAnnotation:annotation animated:animated];
        if (self.zoomLevel != kMapZoomLevel) {
            [self setZoomLevel:kMapZoomLevel animated:animated];
        }
    }
}

- (void)addAnnotationWithStation:(HBBicycleStationModel *)model
{
    HBBicyclePointAnnotation *annotation = [[HBBicyclePointAnnotation alloc] initWithStation:model];
    [self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self addAnnotation:annotation];
}

- (void)setNaviRoute:(AMapNaviRoute *)route
    withStationIndex:(NSUInteger)index {
    //设置中心点
    [self setCenterCoordinate:CLLocationCoordinate2DMake(route.routeCenterPoint.latitude, route.routeCenterPoint.longitude)];
    HBBicyclePointAnnotation *annotation = self.annotations[index];
    [self selectAnnotation:annotation animated:NO];
    //设置显示区域
    [self setRegion:[HBMapManager getRegionFromNaviRoute:route] animated:YES];
    //显示路径
    [self removeOverlays:self.overlays];
    [self addOverlay:[HBNaviManager getPolylineFromRoutes:route]];
}
@end
