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


@interface TodayViewController () <NCWidgetProviding,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 最近可还
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRestoreable;
@property (weak, nonatomic) IBOutlet UIView *viewRestoreable;

/**
 最近可借
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRentable;
@property (weak, nonatomic) IBOutlet UIView *viewRentable;

/**
 最近可还
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

/**
 定位权限/网络权限提示
 */
@property (nonatomic, strong) UILabel *lblTips;

@end

NSString *const kLocateTips = @"请允许定位，获得更佳体验";        //打开定位提示
NSString *const kLocateFail = @"定位失败啦";                   //定位失败
NSString *const kNetworkFail = @"网络出错啦";                  //数据更新失败
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
    //设定折叠模式最大Size
#ifdef __IPHONE_10_0
    //如果需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
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
//    self.view.frame = CGRectMake(0, 0, 375, 500);
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
        if ([self.view.subviews containsObject:self.lblTips]) {
            self.viewRentable.hidden = NO;
            self.viewRestoreable.hidden = NO;
            [self.lblTips removeFromSuperview];
            self.lblTips = nil;
        }
        [self.locationManager requestLocation];
    }else {
        [self addTipWithText:kLocateTips];
    }

}

#pragma mark - LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //恢复显示
    self.viewRentable.hidden = NO;
    self.viewRestoreable.hidden = NO;
    [self.lblTips removeFromSuperview];
    self.lblTips = nil;
    
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
        if (weakSelf.lblTips) {
            if (weakSelf.lblTips) {
                weakSelf.viewRentable.hidden = NO;
                weakSelf.viewRestoreable.hidden = NO;
                [weakSelf.lblTips removeFromSuperview];
                weakSelf.lblTips = nil;
            }
        }
        NSData *resposneData = request.responseData;
        NSDictionary *dic = [NSDictionary fh_dictionaryWithData:resposneData];
        HBBicycleResultModel *resultModel = [HBBicycleResultModel mj_objectWithKeyValues:dic];
        HBBicycleStationModel *rentResult = [resultModel nearestRentableStation];
        HBBicycleStationModel *restoreResult = [resultModel nearestRestoreableStation];
        weakSelf.lblRentable.text = rentResult.name;
        weakSelf.lblRestoreable.text = restoreResult.name;
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
