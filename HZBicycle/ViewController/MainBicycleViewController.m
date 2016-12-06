//
//  MainBicycleViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/10/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainBicycleViewController.h"

#import "MainSettingViewController.h"
#import "MainSearchViewController.h"
#import "HBStationsViewController.h"

#import "HBLocationButton.h"

@interface MainBicycleViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,HBSearchBarDelegete,UINavigationControllerDelegate,SeachViewControllerDelegate,HBStationsViewControllerDelegate,HBNaviDelegate>

#pragma mark - Views
/**
 地图视图
 */
@property (nonatomic, strong) HBBaseMapView *mapView;

/**
 定位控制器
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

/**
 定位按钮
 */
@property (nonatomic, strong) HBLocationButton *locationButton;

/**
 设置按钮
 */
@property (nonatomic, strong) HBBaseRoundButton *settingButton;

/**
 站点数组
 */
@property (nonatomic, strong) NSArray *stationArray;

@property (nonatomic, strong) HBBicycleResultModel *stationResult;

@end

//按钮宽度
static CGFloat const kButtonWidth = 50.f;
static CGFloat const kContentInsets = 15.f;

@implementation MainBicycleViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置定位精度
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.delegate = self;
    
    //注册通知
    [self registerNotifications];
    //注册导航代理
    [self registerNaviDelegate];
    //设置地图视图
    [self setupMapView];
    //设置定位按钮等
    [self setupButtons];
    //设置搜索框
    [self setupSearchBar];
    //开启一次定位
    [self reloadLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //隐藏导航栏
//    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfflineMapFinished:) name:kNotificationOfflineMapFinished object:nil];
}

- (void)registerNaviDelegate {
    [HBNaviManager sharedManager].delegate = self;
}

- (void)setupMapView {
    //添加地图
    self.mapView = [[HBBaseMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
    self.mapView.zoomLevel = 15;
    //无法调整角度
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.delegate = self;
    
    //设置中心点
    if (self.mapView.userLocation.location) {
        self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    } else{
        //设置为杭州中心点
        self.mapView.centerCoordinate = [HBMapManager hangZhouCenter];
    }
    
    //设置指南针位置下移
    self.mapView.showsCompass = NO;
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, self.view.frame.size.height - 40);
    
    [self.view addSubview:self.mapView];
}
- (void)setupButtons {
    @WEAKSELF;
    self.locationButton = [[HBLocationButton alloc] initWithIconImage:ImageInName(@"main_location") clickBlock:^{
        [weakSelf reloadLocation];
    }];
    [self.view addSubview:self.locationButton];
    
    self.settingButton = [[HBBaseRoundButton alloc] initWithIconImage:ImageInName(@"main_setting") clickBlock:^{
        MainSettingViewController *settingVC = [[MainSettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    }];
    [self.view addSubview:self.settingButton];
    //布局有bug，iOS8下面崩溃
    if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_0) {
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kButtonWidth);
            make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset( -kButtonWidth * 2);
            make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
        }];
        [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kButtonWidth);
            make.top.equalTo(weakSelf.locationButton.mas_bottom).with.offset(kContentInsets);
            make.right.equalTo(weakSelf.locationButton.mas_right);
        }];
    } else {
        self.locationButton.frame = CGRectMake(self.view.frame.size.width - kButtonWidth - kContentInsets, self.view.frame.size.height - 2 * kButtonWidth - 2*kContentInsets, kButtonWidth, kButtonWidth);
        self.settingButton.frame = CGRectMake(self.view.frame.size.width - kButtonWidth - kContentInsets, self.view.frame.size.height - kButtonWidth - kContentInsets, kButtonWidth, kButtonWidth);
    }
}

- (void)setupSearchBar {
    @WEAKSELF;
    self.searchBar = [[HBSearchBar alloc] initWithShowType:HBSearchBarShowTypeSearch];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).with.offset(15.f);
        make.height.mas_equalTo(@50);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
    }];
}

#pragma mark - Location
/**
 发送单次定位请求
 */
- (void)reloadLocation {
    @WEAKSELF;
    [weakSelf.locationButton startActivityAnimation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (location) {
            [weakSelf.mapView setCenterCoordinate:location.coordinate animated:YES];
            CLLocationCoordinate2D wgs84Coordinate = [DFLocationConverter gcj02ToWgs84:location.coordinate];
            [HBRequestManager sendNearBicycleRequestWithLatitude:@(wgs84Coordinate.latitude)
                                                      longtitude:@(wgs84Coordinate.longitude)
                                                          length:@([HBUserDefultsManager searchDistance])
                                               successJsonObject:^(NSDictionary *jsonDict) {
                                                   [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
                                                   weakSelf.stationResult = [HBBicycleResultModel mj_objectWithKeyValues:jsonDict];
                                                   if (weakSelf.stationResult.count) {
                                                       [weakSelf.mapView addBicycleStations:weakSelf.stationResult WithIndex:0];
                                                   }else {
                                                       //提示周围没有自行车
                                                       [HBHUDManager showBicycleSearchResult];
                                                   }
                                                   [weakSelf.locationButton endActivityAnimation];
                                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                               } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                   [weakSelf.locationButton endActivityAnimation];
                                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                               }];
        }
    }];
}

#pragma mark - MapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    @WEAKSELF;
    if ([annotation isKindOfClass:[HBBicyclePointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
    
        HBBicycleAnnotationView *annotationView = (HBBicycleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[HBBicycleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.handlePopViewTaped = ^(HBBicyclePointAnnotation *annoation) {
                [weakSelf.mapView deselectAnnotation:annotation animated:YES];
                //截图提供背景
                __block UIImage *screenshotImage = nil;
                __block NSInteger resState = 0;
                @WEAK_OBJ(annoation);
                [weakSelf.mapView takeSnapshotInRect:weakSelf.view.frame withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
                    screenshotImage = resultImage;
                    resState = state;
                    if (screenshotImage && resState) {
                        HBStationsViewController *stationsVC = [[HBStationsViewController alloc] initWithStations:weakSelf.stationResult index:[weakSelf.stationResult.data indexOfObject:annoationWeak.station] blurBackImage:screenshotImage];
                        stationsVC.delegate = self;
                        [weakSelf addChildViewController:stationsVC];
                        [weakSelf.view addSubview:stationsVC.view];
                    }
                }];

            };
        }
        return annotationView;
    }else {
        return nil;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = HB_COLOR_DARKBLUE;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
#warning color may needs to adjust
        return polylineRenderer;
    }
    return nil;
}

- (void)offlineDataDidReload:(MAMapView *)mapView {
    [mapView reloadMap];
}

#pragma mark - HBSearchBarDelegate
- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar {
    [self.searchBar resignSearchBarWithFinish:NO];
    MainSearchViewController *searchViewController = [[MainSearchViewController alloc] init];
    searchViewController.delegate = self;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - SearchViewControllerDelegate
- (void)searchViewController:(MainSearchViewController *)searchVC didChooseIndex:(NSUInteger)index inResults:(HBBicycleResultModel *)results {
    if (!self.mapView.userLocation) {
        [self reloadLocation];
    }
//    CLLocationCoordinate2D mylocation = self.mapView.userLocation.coordinate;
//    //搜索返回结果没有距离，手动添加
//    for (HBBicycleStationModel *station in results.data) {
//        NSUInteger distance = [HBMapManager getDistanceFromPoint:mylocation toAnotherPoint:AMapCoordinateConvert(CLLocationCoordinate2DMake(station.lat, station.lon),AMapCoordinateTypeBaidu)];
//        station.len = distance;
//    }
    [self showStationDetailWithStations:results stationIndex:index];
}

#pragma mark - StationsViewControllerDelegate
- (void)stationViewController:(HBStationsViewController *)stationVC didSelectedIndex:(NSUInteger)index inStations:(HBBicycleResultModel *)stations {
    if (self.stationResult == stations) {
        [self.mapView selectAnnotation:self.mapView.annotations[index] animated:YES];
        HBBicyclePointAnnotation *annotation = [[HBBicyclePointAnnotation alloc] initWithStation:self.stationResult.data[index]];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
        
#warning to push navi vc with station
        //处理导航
        HBBicycleStationModel *targetStation = self.stationResult.data[index];
        CLLocationCoordinate2D  realCoordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(targetStation.lat, targetStation.lon),AMapCoordinateTypeBaidu);
        [[HBNaviManager sharedManager] getRouteWithStartCoordinate:self.mapView.userLocation.coordinate endCoordinate:realCoordinate naviType:HBNaviTypeRide];
        
    } else {
        self.stationResult = stations;
        [self.mapView addBicycleStations:self.stationResult WithIndex:index];
    }

}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (([fromVC isKindOfClass:[MainBicycleViewController class]] && [toVC isKindOfClass:[MainSearchViewController class]]) ||
        ([fromVC isKindOfClass:[MainSearchViewController class]] && [toVC isKindOfClass:[MainBicycleViewController class]])) {
        return [[HBSearchTransition alloc] init];
    }else {
        return nil;
    }
}

#pragma mark - HBNaviManagerDelegate
- (void)finishCalculatedRouteInType:(HBNaviType)type route:(AMapNaviRoute *)route error:(NSError *)error {
    [self.mapView addOverlay:[HBNaviManager getPolylineFromRoutes:route]];
}

#pragma mark - Notification
- (void)handleOfflineMapFinished:(NSNotification *)notification {
    if (self.mapView) {
        //下载完后重新加载地图
        [self.mapView reloadMap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)showStationDetailWithStations:(HBBicycleResultModel *)stations stationIndex:(NSUInteger)index {
    @WEAKSELF;
    //截图提供背景
    __block UIImage *screenshotImage = nil;
    __block NSInteger resState = 0;
    [HBHUDManager showWaitProgress];
    [self.mapView takeSnapshotInRect:weakSelf.view.frame withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenshotImage = resultImage;
        resState = state;
        if (screenshotImage && resState) {
            HBStationsViewController *stationsVC = [[HBStationsViewController alloc] initWithStations:stations index:index blurBackImage:screenshotImage];
            stationsVC.delegate = self;
            [weakSelf addChildViewController:stationsVC];
            [weakSelf.view addSubview:stationsVC.view];
        }
        [HBHUDManager dismissWaitProgress];
    }];
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
