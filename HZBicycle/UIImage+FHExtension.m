//
//  UIImage+FHExtension.m
//  FHKit
//
//  Created by MADAO on 16/8/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "UIImage+FHExtension.h"

@implementation UIImage (FHExtension)

- (UIImage *)cutToRoundImageWithRadius:(CGFloat)radius
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制圆
    CGPoint center = CGPointMake(self.size.width / 2, self.size.height / 2);
    UIBezierPath *outPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.size.width/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CGContextAddPath(context, outPath.CGPath);
    // 剪裁
    CGContextClip(context);
    
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context，并把它设置成为当前正在使用的context(非高清屏方法)
    //    UIGraphicsBeginImageContext(size);
    // 适配高清屏方法
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)imageForSnapShotView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (UIImage *)coreBlurWithBlurLevel:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:self.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (UIImage* )roundSingleColorImageWithColor:(UIColor *)color {
    
    UIView *colorView = [self iconViewWithColor:color];
    UIGraphicsBeginImageContextWithOptions(colorView.bounds.size, NO, 0);
    
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Private Method

+ (UIView *)iconViewWithColor:(UIColor *)color {
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, 32, 32)];
    UIBezierPath *roundBezierPath = [UIBezierPath bezierPath];
    [roundBezierPath addArcWithCenter:iconView.center radius:2.5f startAngle:0 endAngle:2* M_PI clockwise:YES];
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.path = roundBezierPath.CGPath;
    roundLayer.strokeColor               = [color CGColor];
    roundLayer.fillColor                 = [[UIColor clearColor]CGColor];
    roundLayer.lineWidth                 = 5.f;
    [iconView.layer addSublayer:roundLayer];
    return iconView;
}
@end
