//
//  UIView+Frame.h
//  与乐分享
//
//  Created by MADAO on 15/8/14.
//  Copyright (c) 2015年 hare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FHExtension)

// frame.origin.x
@property (nonatomic, assign) CGFloat   x;
// frame.origin.y
@property (nonatomic, assign) CGFloat   y;
// frame.size.width
@property (nonatomic, assign) CGFloat   width;
// frame.size.height
@property (nonatomic, assign) CGFloat   height;
// frame.origin
@property (nonatomic, assign) CGPoint   origin;
// frame.size
@property (nonatomic, assign) CGSize    size;
// center.x
@property (nonatomic, assign) CGFloat   centerX;
// center.y
@property (nonatomic, assign) CGFloat   centerY;
// frame.origin.x + frame.size.width
@property (nonatomic, readonly) CGFloat   maxX;
// frame.origin.y + frame.size.height
@property (nonatomic, readonly) CGFloat   maxY;

@end
