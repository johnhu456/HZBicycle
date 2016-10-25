//
//  ViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "HBBicycleStationModel.h"
@interface ViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *stationArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HBRequestManager config];

    //添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    //设置定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:nil];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addAnnotationWithLocation:(CLLocation *)location
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:location.coordinate];

    [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
    [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
    
    [self addAnnotationToMapView:annotation];
}

- (void)addAnnotationWithStation:(HBBicycleStationModel *)model
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    [annotation setCoordinate: AMapCoordinateConvert(CLLocationCoordinate2DMake(model.lat, model.lon),AMapCoordinateTypeBaidu)];
    [annotation setTitle:model.address];
    [annotation setSubtitle:[NSString stringWithFormat:@"%lu",(unsigned long)model.bikenum]];
    [self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
//    [self.mapView selectAnnotation:annotation animated:YES];
//    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)addStations
{
    for (NSDictionary *dict in self.stationArray) {
        HBBicycleStationModel *model = [HBBicycleStationModel mj_objectWithKeyValues:dict];
        [self addAnnotationWithStation:model];
    }
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location) {
//        CLLocationCoordinate2D baiduCoordinate = AMapCoordinateConvert(location.coordinate,AMapCoordinateTypeBaidu);
//        CLLocation *new = [[CLLocation alloc] initWithLatitude:baiduCoordinate.latitude longitude:baiduCoordinate.longitude];
        [self addAnnotationWithLocation:location];
        [HBRequestManager sendNearBicycleRequestWithLongtitude:@(location.coordinate.longitude) latitude:@(location.coordinate.latitude) length:@(800) successJsonObject:^(NSDictionary *jsonDict) {
            NSLog(@"%@",jsonDict);
            self.stationArray = jsonDict[@"data"];
            [self addStations];
        } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"%@",request);
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
//    }
//    
//    return nil;
}

//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
//{
//    return
//}

@end
