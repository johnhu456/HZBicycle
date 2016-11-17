//
//  HBOfficialContactCell.h
//  HZBicycle
//
//  Created by MADAO on 16/11/17.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 设置Cell的type
 */
typedef NS_ENUM(NSUInteger){
    HBSettintCellTypeDefault = 0, //没有圆角，含下划线
    HBSettintCellTypeTop, //上圆角，含下划线
    HBSettintCellTypeBottom, //下圆角，含下划线
}HBSettintCellType;


@interface HBDefaultSettingCell : UITableViewCell


/**
 初始化设置Cell

 @param title 标题
 @param image 右侧图标
 @param type  显示类型

 @return HBDefaultSettingCell
 */
- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)image
                     cellType:(HBSettintCellType)type;
@end

