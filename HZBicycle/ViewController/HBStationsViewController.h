//
//  HBStationsViewController.h
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBStationsViewController : HBBaseViewController

/**
 初始化方法

 @param stations 数据数组（站点信息）
 @param index    当前想要聚焦的位置
 @param backImage 用来做毛玻璃背景
 */
- (instancetype)initWithStations:(HBBicycleResultModel *)stations
                           index:(NSUInteger)index
                    blurBackImage:(UIImage *)backImage;
@end
