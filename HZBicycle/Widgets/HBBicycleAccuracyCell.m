//
//  HBBicycleAccuracyCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleAccuracyCell.h"

/**
 自定义进度条
 */
@interface CustomSlider : UISlider

@end


@implementation CustomSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    //改变进度条高度
    return CGRectMake(bounds.origin.x, bounds.origin.y + 10.f, bounds.size.width, 10.f);
}

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
@interface HBBicycleAccuracyCell()

/**
 距离显示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

/**
 滑块
 */
@property (weak, nonatomic) IBOutlet CustomSlider *sldDistance;

@end

@implementation HBBicycleAccuracyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置控件颜色
    self.sldDistance.minimumTrackTintColor = HB_COLOR_SLDMIN;
    self.sldDistance.maximumTrackTintColor = HB_COLOR_SLDMAX;
    self.sldDistance.thumbTintColor = HB_COLOR_SLDMID;

}

//处理滑动条滑动
- (IBAction)handleSliderValueChanged:(UISlider *)sender {
    NSInteger intValue = (int)sender.value/100 * 100;
    sender.value = intValue;
    self.lblResult.text = [NSString stringWithFormat:@"%d米",(int)sender.value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
