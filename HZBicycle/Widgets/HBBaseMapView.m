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

- (void)addBicycleStations:(HBBicycleResultModel *)stations
                 WithIndex:(NSUInteger)index {
    [self removeAnnotations:self.annotations];
    self.stationResult = stations;
    for (HBBicycleStationModel *model in self.stationResult.data) {
        [self addAnnotationWithStation:model];
    }
    //设最近的或者选中的为中心点
    if (self.stationResult.data[index]) {
        HBBicyclePointAnnotation *annotation = self.annotations[index];
        [self setCenterCoordinate:annotation.coordinate animated:YES];
        [self selectAnnotation:annotation animated:YES];
        if (self.zoomLevel != kMapZoomLevel) {
            [self setZoomLevel:kMapZoomLevel animated:YES];
        }else {
#warning
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
@end
