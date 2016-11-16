//
//  UIImage+FHExtension.h
//  FHKit
//
//  Created by MADAO on 16/8/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FHExtension)

/**
 *  Cut an image to a round image
 *
 *  @param radius The round's radius
 *
 *  @return The round image
 */
- (UIImage *)cutToRoundImageWithRadius:(CGFloat)radius;

/**
 *  Resize the image to a specific size
 *
 *  @param size The specific size
 *
 *  @return The resized image
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 Get screenshots of the view

 @param The UIView object to take a screenshot

 @return The screenshot,its size is same as the view's
 */
+ (UIImage *)imageForSnapShotView:(UIView *)view;

/**
 Use CoreImage to blur with the image
 
 @param blur  Blur Level

 @return the blured image
 */
- (UIImage *)coreBlurWithBlurLevel:(CGFloat)blur;
@end
