//
//  HBLocationButton.h
//  HZBicycle
//
//  Created by MADAO on 16/10/31.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBLocationButton : UIButton

- (instancetype)initWithClickBlock:(void(^)())block;

/**
 开始加载动画
 */
- (void)startActivityAnimation;

/**
 结束加载动画
 */
- (void)endActivityAnimation;
@end
