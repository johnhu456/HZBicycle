//
//  HBNaviTitleView.h
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBNaviTitleView : UIView

/**
 初始化方法

 @param buttonClicked 按钮点击回调
 */
- (instancetype)initWithButtonOnClicked:(void(^)(NSUInteger buttonIndex))buttonClicked;
                                         
@end
