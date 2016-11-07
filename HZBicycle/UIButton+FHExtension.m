//
//  UIButton+FHExtension.m
//  FHKit
//
//  Created by MADAO on 16/2/17.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "UIButton+FHExtension.h"
#import "FHMarco.h"

@implementation UIButton (Extension)

- (void)fh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

#pragma mark - Private Method
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
