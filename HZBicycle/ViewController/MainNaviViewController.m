//
//  MainNaviViewController.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/6.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainNaviViewController.h"

#import "HBNaviMenuView.h"
#import "HBNaviTitleView.h"

@interface MainNaviViewController ()<AMapNaviDriveViewDelegate,MAMapViewDelegate,HBNaviDelegate>

@property (nonatomic, strong) AMapNaviDriveView *naviDriveView;

@property (nonatomic, weak) HBBicycleResultModel *stationResult;

@property (nonatomic, assign) NSUInteger targetIndex;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) HBBaseMapView *mapView;

@property (nonatomic, strong) HBNaviMenuView *naviMenuView;
@end

static CGFloat const kHeightMenuView = 170.f;        //菜单栏高度
@implementation MainNaviViewController

#pragma mark - Initialize
- (instancetype)initWithStations:(HBBicycleResultModel *)staion
                     targetIndex:(NSUInteger)index
                        location:(CLLocation *)location{
    if (self = [super init]) {
        self.stationResult = staion;
        _targetIndex = index;
        _location = location;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @WEAKSELF;
    //设置地图
    [self setupMapView];
    //获取导航路径
    [self setupNaviRouteWithType:HBNaviTypeWalk];
    //设置菜单页面
    [self setupMenuView];
    HBNaviTitleView *test = [[HBNaviTitleView alloc] initWithButtonOnClicked:^(NSUInteger buttonIndex) {
        [weakSelf setupNaviRouteWithType:buttonIndex == 0 ? HBNaviTypeWalk : HBNaviTypeRide];
    }];
    self.navigationItem.titleView = test;
}

#pragma mark - User Interface

- (void)setupMapView {
    @WEAKSELF;
    self.mapView = [[HBBaseMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    if (_location) {
        [self.mapView setCenterCoordinate:_location.coordinate];
    }else {
        [self.mapView setCenterCoordinate:[HBMapManager hangZhouCenter]];
    }
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuideTop).with.offset(- kHeightMenuView + 5.f);
    }];
    //添加自行车站点数据
    [self.mapView addBicycleStations:self.stationResult withIndex:_targetIndex animated:NO];
}

- (void)setupMenuView {
    @WEAKSELF;
    self.naviMenuView = [[HBNaviMenuView alloc] initWithButtonClick:^(UIButton *sender) {
        if (sender.selected) {
            [weakSelf setupNaviRouteWithType:[HBNaviManager sharedManager].naviType];
        }else {
#warning push new Navi
            [weakSelf setupNaviRouteWithType:[HBNaviManager sharedManager].naviType];
        }
    }];
    [self.view addSubview:self.naviMenuView];
    [self.naviMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(kHeightMenuView);
    }];
}

- (void)setupNaviRouteWithType:(HBNaviType)type {
    //处理导航
    [self.naviMenuView startLoading];
    HBBicycleStationModel *targetStation = self.stationResult.data[_targetIndex];
    CLLocationCoordinate2D  realCoordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(targetStation.lat, targetStation.lon),AMapCoordinateTypeBaidu);
    [HBNaviManager sharedManager].delegate = self;
    [[HBNaviManager sharedManager] getRouteWithStartCoordinate:_location.coordinate endCoordinate:realCoordinate naviType:type];
}

#pragma mark - MapViewDelegate
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[HBBicyclePointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        HBBicycleAnnotationView *annotationView = (HBBicycleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[HBBicycleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        return annotationView;
    }else {
        return nil;
    }
}

#pragma mark - HBNaviManagerDelegate
- (void)finishCalculatedRouteInType:(HBNaviType)type route:(AMapNaviRoute *)route error:(NSError *)error {
    if (!error) {
        [self.mapView setNaviRoute:route withStationIndex:_targetIndex];
        //设置菜单
        self.naviMenuView.route = route;
        self.naviMenuView.station = _stationResult.data[_targetIndex];
        [self.naviMenuView endLoadingWithSuccess:YES];
    } else {
        //路径规划错误，请重试
        [self.naviMenuView endLoadingWithSuccess:NO];
        [HBHUDManager showNaviCalculateError];
    }

}

@end
