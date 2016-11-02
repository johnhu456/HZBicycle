//
//  HBBicycleAnnotationView.h
//  HZBicycle
//
//  Created by MADAO on 16/11/1.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HBBicyclePopView.h"
#import "HBBicyclePointAnnotation.h"

@interface HBBicycleAnnotationView : MAAnnotationView

/**
 自定义气泡
 */
@property (nonatomic, strong, readonly) HBBicyclePopView *popView;

@end
