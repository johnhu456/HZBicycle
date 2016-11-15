//
//  HBSearchResultCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBSearchResultCell.h"


@interface HBSearchResultCell()

/**
 标题标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation HBSearchResultCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width -30.f , self.bounds.size.height);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter
- (void)setStationModel:(HBBicycleStationModel *)stationModel {
    _stationModel = stationModel;
    NSString *title = [stationModel.name stringByAppendingFormat:@"(编号：%ld)",stationModel.number];
    self.lblTitle.text = title;
}

- (void)setBottomCornered:(BOOL)bottomCornered {
    _bottomCornered = bottomCornered;
    if (_bottomCornered) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    if (_bottomCornered && _topCornered) {
        [self setCornered];
        return ;
    }
}

- (void)setTopCornered:(BOOL)topCornered {
    _topCornered = topCornered;
    if (_topCornered) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    if (_bottomCornered && _topCornered) {
        [self setCornered];
        return ;
    }
}

#pragma mark - Private Method
- (void)setCornered {
    self.layer.mask = nil;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
