//
//  HBOfflineMapManager.h
//  HZBicycle
//
//  Created by MADAO on 16/10/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleBaseModel.h"

/**
 完成下载的通知名
 */
extern NSString *const kNotificationOfflineMapFinished;
/**
 以城市为单位进行离线下载，管理的类。
 */
@interface HBOfflineMapManager : HBBicycleBaseModel
/**
 当前选中城市
 */
@property (nonatomic, strong, readonly) MAOfflineCity *selectedCity;

#pragma mark - Public Method
/**
 获取/创建单例
 */
+ (instancetype)sharedManager;

/**
 配置城市，默认杭州
 */
- (void)config;

/**
 清除下载数据
 */
- (void)clearMap;

/**
 以城市代码进行初始化
 */
- (void)configWithCityCode:(NSString *)code;


/**
 下载当前选中城市

 @param downloadBlock 下载回调
 */
- (void)startDownloadWithBlock:(MAOfflineMapDownloadBlock)downloadBlock;

/**
 暂停下载当前选中城市
 */
- (void)stopDownload;

/**
 是否正在下载
 */
- (BOOL)isDownloading;

@end
