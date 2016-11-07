//
//  UIButton+FHExtension.h
//  FHKit
//
//  Created by MADAO on 16/2/17.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 Set button's background color for different state
 May cause conflict with method 'setBackgroundImage:(UIImage *)image forState:(UIControlState)state'
 */
- (void)fh_setBackgroundColor:(UIColor *)backgroundColor
                     forState:(UIControlState)state;
@end
