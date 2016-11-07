//
//  HBBaseRoundButton.h
//  HZBicycle
//
//  Created by MADAO on 16/11/4.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

//icon大小
extern CGFloat const kHBRoundButtonContentInsets;

@interface HBBaseRoundButton : UIButton

/**
 按钮图标
 */
@property (nonatomic, strong, readonly) UIImageView *iconView;

- (instancetype)initWithIconImage:(UIImage *)image clickBlock:(void(^)())block;

@end
