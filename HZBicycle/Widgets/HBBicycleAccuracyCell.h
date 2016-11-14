//
//  HBBicycleAccuracyCell.h
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 自定义滑动条
 */
@interface CustomSlider : UISlider

@end

@interface HBBicycleAccuracyCell : UITableViewCell

@property (nonatomic, copy) void(^handleSldValueChanged)(NSInteger intValue);
/**
 搜索范围
 */
@property (nonatomic, assign) CGFloat searchDistance;

/**
 滑动条
 */
@property (weak, nonatomic) IBOutlet CustomSlider *sldAccuracy;

@end
