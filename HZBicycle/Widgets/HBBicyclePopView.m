//
//  HBBicyclePopView.m
//  HZBicycle
//
//  Created by MADAO on 16/11/1.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicyclePopView.h"

@interface HBBicyclePopView()

#pragma mark - Private Property
/**
 毛玻璃
 */
@property (nonatomic, strong) UIVisualEffectView *blurView;
/**
 标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 可借数量
 */
@property (nonatomic, strong) UILabel *rentNumLabel;
/**
 可还数量
 */
@property (nonatomic, strong) UILabel *returnNumLabel;

@end

static CGFloat const kContentInsets = 15.f;
static CGFloat const kTitleLabelHeight = 15.f;
static CGFloat const kCornerRadius = 20.f;

@implementation HBBicyclePopView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLayer];
        [self setupSubViews];
    }
    return self;
}

//- (void)setupLayer {
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.bounds = self.bounds;
//    
//    layer.backgroundColor = [UIColor blueColor].CGColor;
//    //设置圆角
//    layer.cornerRadius = kCornerRadius;
//    //设置阴影
//    layer.shadowColor = [UIColor blackColor].CGColor;
//    layer.shadowOpacity = 0.8;
//    layer.shadowOffset = CGSizeMake(3, 3);
//    layer.contents = 
//}

- (void)setupSubViews {
    //毛玻璃
    @WEAKSELF;
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self addSubview:self.blurView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(weakSelf);
    }];
    
    //标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = HB_FONT_LIGHT_SIZE(14);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kContentInsets);
        make.top.equalTo(weakSelf.mas_top).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.mas_right).with.offset(-kContentInsets);
        make.height.mas_equalTo(kTitleLabelHeight);
    }];
    
    //可借数量
    self.rentNumLabel = [[UILabel alloc] init];
    self.rentNumLabel.font = HB_FONT_LIGHT_SIZE(12);
    self.rentNumLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rentNumLabel];
    [self.rentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kContentInsets);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(kContentInsets);
        make.height.mas_equalTo(kTitleLabelHeight);
        make.width.equalTo(weakSelf.mas_width).dividedBy(2);
    }];
    
    //可还数量
    self.returnNumLabel = [[UILabel alloc] init];
    self.returnNumLabel.font = HB_FONT_LIGHT_SIZE(12);
    self.returnNumLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.returnNumLabel];
    [self.returnNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTitleLabelHeight);
        make.width.equalTo(weakSelf.mas_width).dividedBy(2);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.mas_right).with.offset(-kContentInsets);
    }];
}

#pragma mark - Setter
- (void)setStationModel:(HBBicycleStationModel *)stationModel {
    _stationModel = stationModel;
    self.titleLabel.text = [stationModel.name stringByAppendingFormat:@"(编号：%ld)",stationModel.number];
    
    //生成圆点图片
    NSTextAttachment *rentAttach = [[NSTextAttachment alloc] init];
    rentAttach.image = [self convertViewToImage:[self iconViewWithColor:HB_COLOR_SOFTGREEN]];
    
    NSTextAttachment *returnAttach = [[NSTextAttachment alloc] init];
    returnAttach.image = [self convertViewToImage:[self iconViewWithColor:HB_COLOR_SOFTORANGE]];
    
    //合成字符串
    NSAttributedString *rentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"可借:%lu",(unsigned long)stationModel.rentcount]
                                                                     attributes:@{
                                                                                NSAttachmentAttributeName:rentAttach,
                                                                                NSFontAttributeName:HB_FONT_LIGHT_SIZE(12)
                                                                                }];
    
    NSAttributedString *returnString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"可还:%lu",(unsigned long)stationModel.restorecount]
                                                                     attributes:@{
                                                                                  NSAttachmentAttributeName:returnAttach,
                                                                                  NSFontAttributeName:HB_FONT_LIGHT_SIZE(12)
                                                                                  }];
    
//    [self.rentNumLabel setText:[NSString stringWithFormat:@"可借:%lu",(unsigned long)stationModel.rentcount]];
//    [self.returnNumLabel setText:[NSString stringWithFormat:@"可还:%lu",(unsigned long)stationModel.restorecount]];
    [self.rentNumLabel setAttributedText:rentString];
    [self.returnNumLabel setAttributedText:returnString];
}

#pragma mark - Icon
-(UIImage* )convertViewToImage:(UIView*)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)snapShot:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIView *)iconViewWithColor:(UIColor *)color {
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, 32, 32)];
    UIBezierPath *roundBezierPath = [UIBezierPath bezierPath];
    [roundBezierPath addArcWithCenter:iconView.center radius:2.25f startAngle:0 endAngle:2* M_PI clockwise:YES];
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.path = roundBezierPath.CGPath;
    roundLayer.strokeColor               = [color CGColor];
    roundLayer.fillColor                 = [[UIColor clearColor]CGColor];
    roundLayer.lineWidth                 = 5.f;
    [iconView.layer addSublayer:roundLayer];
    return iconView;
}

#pragma mark - Private Method

- (void)drawRect:(CGRect)rect {
    
}
@end
