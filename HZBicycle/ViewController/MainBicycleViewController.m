//
//  MainBicycleViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/10/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainBicycleViewController.h"
#import "HBLocationButton.h"

@interface MainBicycleViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

#pragma mark - Views
/**
 地图视图
 */
@property (nonatomic, strong) MAMapView *mapView;

/**
 定位控制器
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

/**
 定位按钮
 */
@property (nonatomic, strong) HBLocationButton *locationButton;

/**
 站点数组
 */
@property (nonatomic, strong) NSArray *stationArray;

@end

//按钮宽度
static CGFloat const kButtonWidth = 50.f;
static CGFloat const kContentInsets = 15.f;


@implementation MainBicycleViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    self.mapView.zoomLevel = 15;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    //设置定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.delegate = self;
    
    //无法调整角度
    self.mapView.rotateCameraEnabled = NO;
    
    //设置定位按钮等
    [self setupButtons];
    
    //开启一次定位
    [self reloadLocation];
}

#pragma mark - Layout

- (void)setupButtons {
    @WEAKSELF;
    self.locationButton = [[HBLocationButton alloc] initWithClickBlock:^{
        [weakSelf reloadLocation];
    }];
    [self.view addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset( -kButtonWidth * 2);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
    }];
    self.locationButton.layer.cornerRadius = kButtonWidth/2.f;
}

#pragma mark - Location
/**
 发送单次定位请求
 */
- (void)reloadLocation {
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (location) {
            [self.mapView setCenterCoordinate:location.coordinate animated:YES];
            CLLocationCoordinate2D wgs84Coordinate = [DFLocationConverter gcj02ToWgs84:location.coordinate];
            [HBRequestManager sendNearBicycleRequestWithLatitude:@(wgs84Coordinate.latitude)
                                                      longtitude:@(wgs84Coordinate.longitude)
                                                          length:@(800)
                                               successJsonObject:^(NSDictionary *jsonDict) {
                                                   self.stationArray = jsonDict[@"data"];
                                                   [self addBicycleStations];
                                                   [self.locationButton endActivityAnimation];
                                               } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                   NSLog(@"%@",request);
                                               }];
        }
    }];
}



/**
 将自行车站添加到地图上
 */
- (void)addBicycleStations {
    for (NSDictionary *dict in self.stationArray) {
        HBBicycleStationModel *model = [HBBicycleStationModel mj_objectWithKeyValues:dict];
        [self addAnnotationWithStation:model];
    }
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

- (void)addAnnotationWithLocation:(CLLocation *)location
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:location.coordinate];
    
    [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
    [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
    
    [self addAnnotationToMapView:annotation];
}

#pragma mark - WidgetsActions


#pragma mark - MapViewDelegate
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
