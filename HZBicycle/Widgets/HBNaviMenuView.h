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

@property (nonatomic, weak) HBBicycleStationModel *station;

@end
