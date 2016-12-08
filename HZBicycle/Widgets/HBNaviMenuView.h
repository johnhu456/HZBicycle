//
//  HBNaviMenuView.h
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/7.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBNaviMenuView : UIView

/**
 路线模型
 */
@property (nonatomic, weak) AMapNaviRoute *route;

/**
 站点模型
 */
@property (nonatomic, weak) HBBicycleStationModel *station;

/**
 是否失败（set会改变按钮状态）
 */
@property (nonatomic, assign) BOOL failure;

/**
 初始化方法
 
 (按钮不可用时需调用一次setFailure:恢复状态)

 @param block 按钮点击回调
 */
- (instancetype)initWithButtonClick:(void(^)(UIButton *sender))block;

@end
