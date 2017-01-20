//
//  UIView+Frame.m
//  与乐分享
//
//  Created by MADAO on 15/8/14.
//  Copyright (c) 2015年 hare. All rights reserved.
//

#import "UIView+FHExtension.h"

@implementation UIView (FHExtension)

- (void)setX:(CGFloat)x{
    
    CGRect rect     = self.frame;
    rect.origin.x   = x;
    self.frame      = rect;
}

- (CGFloat)x{
    
    return CGRectGetMinX(self.frame);
}

- (void)setY:(CGFloat)y{
    
    CGRect rect     = self.frame;
    rect.origin.y   = y;
    self.frame      = rect;
}

- (CGFloat)y{
    
    return CGRectGetMinY(self.frame);
}

- (void)setWidth:(CGFloat)width{
    
    CGRect rect     = self.frame;
    rect.size.width = width;
    self.frame      = rect;
}

- (CGFloat)width{
    
    return CGRectGetWidth(self.frame);
}

- (void)setHeight:(CGFloat)height{
    
    CGRect rect         = self.frame;
    rect.size.height    = height;
    self.frame          = rect;
}

- (CGFloat)height{
    
    return CGRectGetHeight(self.frame);
}

- (void)setOrigin:(CGPoint)origin{
    
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame  = rect;
}

- (CGPoint)origin{
    
    return self.frame.origin;
}

- (void)setSize:(CGSize)size{
    
    CGRect rect = self.frame;
    rect.size   = size;
    self.frame  = rect;
}

- (CGSize)size{
    
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX{
    
    CGPoint center  = self.center;
    center.x        = centerX;
    self.center     = center;
}

- (CGFloat)centerX{
    
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    
    CGPoint center  = self.center;
    center.y        = centerY;
    self.center     = center;
}

- (CGFloat)centerY{
    
    return self.center.y;
}

- (CGFloat)maxX{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY{
    
    return CGRectGetMaxY(self.frame);
}

@end
