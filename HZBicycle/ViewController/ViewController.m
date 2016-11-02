//
//  ViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"

#import "HBBicycleStationModel.h"
@interface ViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *stationArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#warning 单独分理出下载功能
    [[HBOfflineMapManager sharedManager] startDownloadWithBlock:^(MAOfflineItem *downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
        NSLog(@"%@",downloadItem);
        NSLog(@"%ld",(long)downloadStatus);
        NSLog(@"%@",info);
        NSLog(@"======");
        if (downloadStatus == MAOfflineMapDownloadStatusFinished) {
            [self.mapView reloadMap];
        }
    }];
    
    
   }




#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{

}



//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
//{
//    return
//}

@end
