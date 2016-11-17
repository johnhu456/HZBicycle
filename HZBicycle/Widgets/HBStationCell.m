//
//  HBStationCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/16.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBStationCell.h"

@interface HBStationCell ()

/**
 编号标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

/**
 名称标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;

/**
 距离标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

/**
 地址标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblAdress;

/**
 值守类型标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblManagerType;

/**
 电话标签1
 */
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneFirst;

/**
 电话标签2
 */
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneSecond;

/**
 租还时间标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblServiceTime;

/**
 可借标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRentableNumber;

/**
 可还标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblReturnableNumber;

/**
 联系电话标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblContact;

@end

@implementation HBStationCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, [UIScreen mainScreen].bounds.size.width -120 , 300 );
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置字体
    self.lblName.adjustsFontSizeToFitWidth = YES;
    self.lblAdress.adjustsFontSizeToFitWidth = YES;
    [self setupFonts];
    //设置圆角及阴影
    [self setupMaskLayer];
}

- (void)setupFonts {
    self.lblNumber.font = HB_FONT_LIGHT_SIZE(14);
    self.lblName.font = HB_FONT_MEDIUM_SIZE(17);
    self.lblDistance.font = HB_FONT_LIGHT_SIZE(13);
    self.lblAdress.font = HB_FONT_LIGHT_SIZE(13);
    self.lblManagerType.font = HB_FONT_LIGHT_SIZE(13);
    self.lblContact.font = HB_FONT_LIGHT_SIZE(12);
    self.lblPhoneFirst.font = HB_FONT_LIGHT_SIZE(12);
    self.lblPhoneSecond.font = HB_FONT_LIGHT_SIZE(12);
    self.lblServiceTime.font = HB_FONT_LIGHT_SIZE(13);
    self.lblRentableNumber.font = HB_FONT_LIGHT_SIZE(15);
    self.lblReturnableNumber.font = HB_FONT_LIGHT_SIZE(15);
}

- (void)setupMaskLayer {
//    self.layer.cornerRadius = 5.f; 渲染容易卡顿，弃用
    CGRect shadowRect = CGRectMake(0, 0, self.bounds.size.width - 8, self.bounds.size.height - 8);
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:5.f];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = roundRectPath.CGPath;
    maskLayer.frame = shadowRect;
    maskLayer.shadowColor = [UIColor blackColor].CGColor;
    maskLayer.shadowOpacity = 0.8;
    maskLayer.shadowOffset = CGSizeMake(2, 2);
    self.layer.mask = maskLayer;
}

#pragma mark - Setter 
- (void)setStation:(HBBicycleStationModel *)station {
    _station = station;
    self.lblNumber.text = [NSString stringWithFormat:@"NO:%ld",station.number];
    self.lblName.text = station.name;
    self.lblDistance.text = [NSString stringWithFormat:@"距离%d米",(int)station.len];
    self.lblAdress.text = station.address;
    self.lblManagerType.text = station.guardType;
    self.lblPhoneFirst.text = station.stationPhone;
    self.lblPhoneSecond.text = station.stationPhone2;
    self.lblServiceTime.text = station.serviceType;
#warning 可还可借
    
}
@end
