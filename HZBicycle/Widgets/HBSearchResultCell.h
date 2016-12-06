//
//  HBSearchResultCell.h
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSearchResultCell : UITableViewCell

/**
 站点模型
 */
@property (nonatomic, strong) HBBicycleStationModel *stationModel;

/**
 底部圆角
 */
@property (assign, nonatomic) BOOL bottomCornered;

/**
 顶部圆角
 */
@property (assign, nonatomic) BOOL topCornered;

/**
 设置最近搜索内容
 */
- (void)setRecentSearchText:(NSString *)text;

@end
