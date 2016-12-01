//
//  HBNaviManager.h
//  HZBicycle
//
//  Created by 胡翔 on 2016/11/30.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

/**
 导航类型
 
 - HBNaviTypeWalk: 步行导航
 - HBNaviTypeRide: 骑行导航
 */
typedef NS_ENUM(NSUInteger, HBNaviType){
    HBNaviTypeWalk = 0,
    HBNaviTypeRide
};

@interface HBNaviManager : NSObject
#pragma mark - Property
/**
 导航管理（步行/骑行，无法同时生成实例）
 */
@property (nonatomic, strong, readonly) AMapNaviBaseManager *naviManager;

/**
 导航类型
 */
@property (nonatomic, assign) HBNaviType naviType;

/**
 起始点
 */
@property (nonatomic, strong) AMapNaviPoint *startPoint;

/**
 结束点
 */
@property (nonatomic, strong) AMapNaviPoint *endPoint;

#pragma mark - Class Method
/**
 单例
 */
+ (instancetype)sharedManager;

#pragma mark - Instance Method
/**
 获取导航路径

 @param start 起始点
 @param end 结束点
 @param type 导航类型
 */
- (void)getRouteWithStartCoordinate:(CLLocationCoordinate2D)start
                      endCoordinate:(CLLocationCoordinate2D)end
                           naviType:(HBNaviType)type;

/**
 设置导航类型
 如果未等上一个导航回调完成，直接调用此方法可能导致上一个导航回调失效。
 
 @param naviType 导航类型
 @param recalculate 是否立即重新计算（为NO则需要手动调用上面getRoute方法才能更新路线）
 */
- (void)setNaviType:(HBNaviType)naviType
    withRecalculate:(BOOL)recalculate;
@end
