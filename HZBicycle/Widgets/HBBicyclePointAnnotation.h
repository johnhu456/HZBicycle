//
//  HBBicyclePointAnnotation.h
//  HZBicycle
//
//  Created by MADAO on 16/11/2.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface HBBicyclePointAnnotation : MAPointAnnotation

/**
 站点信息
 */
@property (nonatomic, weak, readonly) HBBicycleStationModel *station;

/**
 使用站点信息进行初始化

 @param station 站点信息

 @return 标记点对象
 */
- (instancetype)initWithStation:(HBBicycleStationModel *)station;

@end
