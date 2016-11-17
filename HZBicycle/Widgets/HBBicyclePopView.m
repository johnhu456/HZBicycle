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
 毛玻璃遮罩
 */
@property (nonatomic, strong) CAShapeLayer *blurMaskLayer;

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

static CGFloat const kContentInsets = 10.f;
static CGFloat const kShadowAdd = 3.f;
static CGFloat const kShadowInsets = 12.f;
static CGFloat const kTitleLabelHeight = 15.f;
static CGFloat const kCornerRadius = 5.f;
static CGFloat const kArrorHeight = 10.f;

@implementation HBBicyclePopView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        [self setupLayer];
        [self setupTapGesture];
    }
    return self;
}

- (void)setupSubViews {
    //毛玻璃
    @WEAKSELF;
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurView.layer.mask = self.blurMaskLayer;
    [self addSubview:self.blurView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(weakSelf);
    }];
    
    //标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = HB_FONT_LIGHT_SIZE(14);
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kContentInsets);
        make.top.equalTo(weakSelf.mas_top).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.mas_right).with.offset(-2 * kContentInsets);
        make.height.mas_equalTo(kTitleLabelHeight);
    }];
    
    //可借数量
    self.rentNumLabel = [[UILabel alloc] init];
    self.rentNumLabel.font = HB_FONT_LIGHT_SIZE(12);
    self.rentNumLabel.textColor = [UIColor whiteColor];
    self.rentNumLabel.textAlignment = NSTextAlignmentLeft;
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
    self.returnNumLabel.textColor = [UIColor whiteColor];
    self.returnNumLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.returnNumLabel];
    [self.returnNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTitleLabelHeight);
        make.width.equalTo(weakSelf.mas_width).dividedBy(2);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.mas_right).with.offset(- 3 * kContentInsets);
    }];
}

- (void)setupLayer {
    [self layoutIfNeeded];
    //清除上一次数据
    [self.blurMaskLayer removeFromSuperlayer];
    self.blurView.layer.mask = nil;
    self.blurMaskLayer = nil;
    //设置遮罩layer
    self.blurMaskLayer = [[CAShapeLayer alloc] init];
    self.blurMaskLayer.frame = self.bounds;
    //设置阴影
    self.blurMaskLayer.shadowColor = [UIColor blackColor].CGColor;
    self.blurMaskLayer.shadowOpacity = 0.8;
    self.blurMaskLayer.shadowOffset = CGSizeMake(2, 2);
    //绘制曲线
    CGPoint leftTopCenter = CGPointMake(self.bounds.origin.x + kCornerRadius + kShadowAdd, self.bounds.origin.y + kCornerRadius);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:leftTopCenter radius:kCornerRadius startAngle:M_PI endAngle:1.5 * M_PI clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(self.bounds.size.width - kCornerRadius - kShadowInsets, self.bounds.origin.y)];
    CGPoint rightTopCenter = CGPointMake(self.bounds.size.width - kCornerRadius - kShadowInsets, self.bounds.origin.y + kCornerRadius);
    [maskPath addArcWithCenter:rightTopCenter radius:kCornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(self.bounds.size.width - kShadowInsets, self.bounds.size.height - kCornerRadius - kArrorHeight - kShadowInsets - kShadowInsets)];
    CGPoint rightBottomCenter = CGPointMake(self.bounds.size.width - kCornerRadius - kShadowInsets, self.bounds.size.height - kCornerRadius - kArrorHeight - kShadowInsets);
    [maskPath addArcWithCenter:rightBottomCenter radius:kCornerRadius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) + kArrorHeight/2.f, self.bounds.size.height - kArrorHeight - kShadowInsets)];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height - kShadowInsets)];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) - kArrorHeight/2.f, self.bounds.size.height - kArrorHeight - kShadowInsets)];
    [maskPath addLineToPoint:CGPointMake(self.bounds.origin.x + kCornerRadius + kShadowAdd, self.bounds.size.height - kArrorHeight - kShadowInsets)];
    CGPoint leftBottomCenter = CGPointMake(self.bounds.origin.x + kCornerRadius + kShadowAdd, self.bounds.size.height - kArrorHeight - kCornerRadius - kShadowInsets);
    [maskPath addArcWithCenter:leftBottomCenter radius:kCornerRadius startAngle:0.5 * M_PI endAngle:M_PI clockwise:YES];
    [maskPath closePath];
    self.blurMaskLayer.path = maskPath.CGPath;
    self.blurView.layer.mask = self.blurMaskLayer;
    self.blurMaskLayer.shadowPath = maskPath.CGPath;
}

- (void)setupTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaped:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Setter
- (void)setStationModel:(HBBicycleStationModel *)stationModel {
    _stationModel = stationModel;
    self.titleLabel.text = [stationModel.name stringByAppendingFormat:@"(编号：%ld)",stationModel.number];
    
    //生成圆点图片
    NSTextAttachment *rentAttach = [[NSTextAttachment alloc] init];
    rentAttach.bounds = CGRectMake(13, -12, 32, 32);
//    rentAttach.image = [self convertViewToImage:[self iconViewWithColor:HB_COLOR_SOFTGREEN]];
    rentAttach.image = [UIImage roundSingleColorImageWithColor:HB_COLOR_SOFTGREEN];
    
    NSTextAttachment *returnAttach = [[NSTextAttachment alloc] init];
    returnAttach.bounds = CGRectMake(13, -12, 32, 32);
    returnAttach.image = [UIImage roundSingleColorImageWithColor:HB_COLOR_SOFTORANGE];
    
    //合成字符串
    NSMutableAttributedString *rentString = [[NSMutableAttributedString attributedStringWithAttachment:rentAttach] mutableCopy];
    
    

    
    NSMutableAttributedString *returnString = [[NSAttributedString attributedStringWithAttachment:returnAttach] mutableCopy];

    [rentString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可借：%lu",(unsigned long)stationModel.rentcount]
                                                                              attributes:@{
                                                                                           NSFontAttributeName:HB_FONT_LIGHT_SIZE(12)
                                                                                           }]];
    
    [returnString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可还：%lu",(unsigned long)stationModel.restorecount]
                                                                                attributes:@{
                                                                                            NSFontAttributeName:HB_FONT_LIGHT_SIZE(12)
                                                                                            }]];
    [self.rentNumLabel setAttributedText:rentString];
    [self.returnNumLabel setAttributedText:returnString];

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupLayer];
}

- (void)setHandleTaped:(void (^)())handleTaped {
    _handleTaped = handleTaped;
}

#pragma mark - Icon
- (UIImage* )convertViewToImage:(UIView*)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIView *)iconViewWithColor:(UIColor *)color {
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

#pragma mark - Private Method
- (void)popAnimation {
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

- (void)handleTaped:(UIGestureRecognizer *)gesture {
    if (self.handleTaped) {
        self.handleTaped();
    }
}
@end
