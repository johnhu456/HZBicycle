//
//  HBBicyclePopView.h
//  HZBicycle
//
//  Created by MADAO on 16/11/1.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBicyclePopView : UIView
//站点模型
@property (nonatomic, strong) HBBicycleStationModel *stationModel;

/**
 点击回调
 */
@property (nonatomic, copy) void(^handleTaped)();

//显示动画
- (void)popAnimation;

@end
