//
//  HBBaseMapView.h
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/6.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HBBicyclePointAnnotation.h"
#import "HBBicycleAnnotationView.h"
#import "HBBicycleResultModel.h"
/**
 继承自MAMapView
 主要为了添加标记方法做统一接口，代码复用
 后续可能还会改动
 */
@interface HBBaseMapView : MAMapView

/**
 添加想要显示的站点信息和焦点站点的下标

 @param stations 站点信息
 @param index 下标
 */
- (void)addBicycleStations:(HBBicycleResultModel *)stations
                 WithIndex:(NSUInteger)index;

@end
