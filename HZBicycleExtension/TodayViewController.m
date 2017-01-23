//
//  TodayViewController.m
//  HZBicycleExtension
//
//  Created by 胡翔 on 2017/1/22.
//  Copyright © 2017年 MADAO. All rights reserved.
//

#import "TodayViewController.h"

#import <MapKit/MapKit.h>
#import <NotificationCenter/NotificationCenter.h>
#import <Masonry.h>
#import <MJExtension.h>

#import "HBUserDefultsManager.h"
#import "HBRequestManager.h"
#import "HBBicycleResultModel.h"

#import "NSDictionary+FHExtension.h"
#import "UIImage+FHExtension.h"


@interface TodayViewController () <NCWidgetProviding,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 最近可还
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRestoreable;    //可还标签
@property (weak, nonatomic) IBOutlet UIView *viewRestoreable;
@property (weak, nonatomic) IBOutlet UIImageView *iconRestoreable;  //可还icon
@property (weak, nonatomic) IBOutlet UILabel *countRestoreable;  //可还数量

/**
 最近可借
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRentable;   //可借标签
@property (weak, nonatomic) IBOutlet UIView *viewRentable;
@property (weak, nonatomic) IBOutlet UIImageView *iconRentable; //可借icon
@property (weak, nonatomic) IBOutlet UILabel *countRentable;  //可借数量

/**
 最近可还
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

/**
 最近可还站点
 */
@property (nonatomic, strong) HBBicycleStationModel *nearestRestoreableStation;

/**
 最近可借站点
 */
@property (nonatomic, strong) HBBicycleStationModel *nearestRentableStation;

/**
 定位权限/网络权限提示
 */
@property (nonatomic, strong) UILabel *lblTips;

@end

NSString *const kLocateTips = @"请允许定位，获得更佳体验";        //打开定位提示
NSString *const kLocateFail = @"定位失败啦";                   //定位失败
NSString *const kNetworkFail = @"网络出错啦";                  //数据更新失败
NSString *const kNetworkFetching = @"数据获取中";              //数据获取中
NSString *const kNearByNoData = @"附近无可用站点数据";          //附近无站点信息
NSString *const kNoAcceptable = @"找不到符合的站点";            //无符合站点

CGFloat const kTipInsetsTop = 20.f;                          //上边距
CGFloat const kTipInsetsLeft = 8.f;                          //左边距
CGFloat const kTipInsetsHeight = 70.f;                       //高度

@implementation TodayViewController

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorView;
}

- (UILabel *)lblTips {
    if (_lblTips == nil) {
        _lblTips = [[UILabel alloc] init];
        _lblTips.textAlignment = NSTextAlignmentCenter;
        _lblTips.font = [UIFont systemFontOfSize:15];
        _lblTips.textColor = [UIColor darkGrayColor];
        _lblTips.text = kLocateTips;
    }
    return _lblTips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblRentable.adjustsFontSizeToFitWidth = YES;
    self.lblRestoreable.adjustsFontSizeToFitWidth = YES;
    self.iconRestoreable.image = [UIImage imageNamed:@"round_softorange"];
    self.iconRentable.image = [UIImage imageNamed:@"round_softgreen"];
    //设定折叠模式最大Size
#ifdef __IPHONE_10_0
    //如果需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
#endif
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTipWithText:kNetworkFetching];
}

#pragma mark - WidgetsDisplayModeChange 
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
#ifdef __IPHONE_10_0
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize =  maxSize;
    }else {
        self.preferredContentSize = CGSizeMake(0, 110);
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%f",[HBUserDefultsManager searchDistance]);
    [self startLocateAndGetData];
}

#pragma mark - DataFetch/Process
- (void)startLocateAndGetData {
    //开始定位并获取数据
    if ([CLLocationManager locationServicesEnabled]) {
        [self addTipWithText:kNetworkFetching];
        [self.locationManager requestLocation];
    }else {
        [self addTipWithText:kLocateTips];
    }

}

#pragma mark - HandleTap

- (IBAction)handleLabelRestoreOnTap:(UITapGestureRecognizer *)sender {
    if (self.nearestRestoreableStation) {
        NSString *urlString = [NSString stringWithFormat:@"PBicycles://getWithStationID?stationId=%ld",self.nearestRestoreableStation.stationID];
        [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:nil];
    }
}

- (IBAction)handleLabelRentOnTap:(UITapGestureRecognizer *)sender {
    if (self.nearestRentableStation) {
        NSString *urlString = [NSString stringWithFormat:@"PBicycles://getWithStationID?stationId=%ld",self.nearestRentableStation.stationID];
        [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:nil];
    }
}

#pragma mark - LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    [self addTipWithText:kNetworkFetching];
    CLLocation *result = [locations lastObject];
    CLLocationCoordinate2D coordinate = result.coordinate;
    __weak typeof(self) weakSelf = self;
    //请求周边数据
    [HBRequestManager config];
    HBNearBicycleRequest *nearBicycleRequest =  [[HBNearBicycleRequest alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObjectOrNil:@(coordinate.longitude) forKey:@"lng"];
    [params setObjectOrNil:@(coordinate.latitude) forKey:@"lat"];
    [params setObjectOrNil:@([HBUserDefultsManager searchDistance]) forKey:@"len"];
    nearBicycleRequest.requestArguments = params;
    [nearBicycleRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData *resposneData = request.responseData;
        NSDictionary *dic = [NSDictionary fh_dictionaryWithData:resposneData];
        HBBicycleResultModel *resultModel = [HBBicycleResultModel mj_objectWithKeyValues:dic];
        [HBUserDefultsManager saveLastExtensionSearchWithResult:resultModel];
        HBBicycleStationModel *rentResult = [resultModel nearestRentableStation];
        HBBicycleStationModel *restoreResult = [resultModel nearestRestoreableStation];
        weakSelf.nearestRentableStation = rentResult;
        weakSelf.nearestRestoreableStation = restoreResult;
        if (rentResult == nil && restoreResult == nil) {
            //附近无任何数据
            [weakSelf addTipWithText:kNearByNoData];
        }else {
            //仅有单一数据
            weakSelf.lblRestoreable.text = restoreResult ? restoreResult.name : kNoAcceptable;
            weakSelf.lblRentable.text = rentResult ? rentResult.name : kNoAcceptable;
            weakSelf.countRestoreable.text = restoreResult ? [NSString stringWithFormat:@"%lu",(unsigned long)restoreResult.restorecount] : @"";
            weakSelf.countRentable.text = rentResult ? [NSString stringWithFormat:@"%lu",(unsigned long)rentResult.rentcount] : @"";
            [weakSelf removeTipAndDisplay];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //提示网路错误
        [weakSelf addTipWithText:kNetworkFail];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self addTipWithText:kLocateFail];
}

#pragma mark - PrivateMethod
- (void)addTipWithText:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    self.viewRentable.hidden = YES;
    self.viewRestoreable.hidden = YES;
    if ([self.view.subviews containsObject:self.lblTips]){
        self.lblTips.text = text;
        return;
    }
    [self.view addSubview:self.lblTips];
    [self.lblTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(kTipInsetsTop);
        make.height.mas_equalTo(kTipInsetsHeight);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(kTipInsetsLeft);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kTipInsetsLeft);
    }];
    self.lblTips.text = text;
}

- (void)removeTipAndDisplay {
    //恢复显示
    if ([self.view.subviews containsObject:self.lblTips]) {
        self.viewRentable.hidden = NO;
        self.viewRestoreable.hidden = NO;
        [self.lblTips removeFromSuperview];
        self.lblTips = nil;
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
