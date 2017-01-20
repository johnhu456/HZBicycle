//
//  MainNaviViewController.h
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/6.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBaseViewController.h"

@interface MainNaviViewController : HBBaseViewController

/**
 初始化方法

 @param staion 自行车站点结果
 @param index 目标站点下标
 @return MainNaviViewController
 */
- (instancetype)initWithStations:(HBBicycleResultModel *)staion
                     targetIndex:(NSUInteger)index
                        location:(CLLocation *)location;
@end
