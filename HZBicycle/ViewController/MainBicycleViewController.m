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
#import "HBBicyclePointAnnotation.h"
#import "HBBicycleAnnotationView.h"

@interface MainBicycleViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,HBSearchBarDelegete,UINavigationControllerDelegate,SeachViewControllerDelegate,HBStationsViewControllerDelegate>

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

static CGFloat const kMapZoomLevel = 15;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfflineMapFinished:) name:kNotificationOfflineMapFinished object:nil];
}
- (void)setupMapView {
    //添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
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
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset( -kButtonWidth * 2);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
    }];
    
    self.settingButton = [[HBBaseRoundButton alloc] initWithIconImage:ImageInName(@"main_setting") clickBlock:^{
        MainSettingViewController *settingVC = [[MainSettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    }];
    [self.view addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.top.equalTo(weakSelf.locationButton.mas_bottom).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.locationButton.mas_right);
    }];
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
                                                   NSLog(@"%@",weakSelf.stationResult);
                                                   if (weakSelf.stationResult.count) {
                                                       [weakSelf addBicycleStationsWithIndex:0];
                                                   }else {
                                                       //提示周围没有自行车
                                                       [HBHUDManager showBicycleSearchResult];
                                                   }
                                                   [weakSelf.locationButton endActivityAnimation];

                                               } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                   NSLog(@"%@",request);
                                                   [weakSelf.locationButton endActivityAnimation];
                                               }];
        }
    }];
}

/**
 将自行车站添加到地图上
 */
- (void)addBicycleStationsWithIndex:(NSUInteger)index {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (HBBicycleStationModel *model in self.stationResult.data) {
        [self addAnnotationWithStation:model];
    }
    //设最近的或者选中的为中心点
    if (self.stationResult.data[index]) {
        HBBicyclePointAnnotation *annotation = self.mapView.annotations[index];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
        [self.mapView selectAnnotation:annotation animated:YES];
        if (self.mapView.zoomLevel != kMapZoomLevel) {
            [self.mapView setZoomLevel:kMapZoomLevel animated:YES];
        }
    }else{
#warning
    }
}

- (void)addAnnotationWithStation:(HBBicycleStationModel *)model
{
    HBBicyclePointAnnotation *annotation = [[HBBicyclePointAnnotation alloc] initWithStation:model];
    [self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
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

- (void)offlineDataDidReload:(MAMapView *)mapView {
    NSLog(@"OFFLINEMAP LOADED");
}

#pragma mark - HBSearchBarDelegate
- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar {
    NSLog(@"begin");
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
    } else {
        self.stationResult = stations;
        [self addBicycleStationsWithIndex:index];
    }

}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([fromVC isKindOfClass:[MainBicycleViewController class]] && [toVC isKindOfClass:[MainSearchViewController class]]) {
        return [[HBSearchTransition alloc] init];
    }else {
        return nil;
    }
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
    [self.mapView takeSnapshotInRect:weakSelf.view.frame withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenshotImage = resultImage;
        resState = state;
        if (screenshotImage && resState) {
            HBStationsViewController *stationsVC = [[HBStationsViewController alloc] initWithStations:stations index:index blurBackImage:screenshotImage];
            stationsVC.delegate = self;
            [weakSelf addChildViewController:stationsVC];
            [weakSelf.view addSubview:stationsVC.view];
        }
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
