//
//  HBBaseRoundButton.m
//  HZBicycle
//
//  Created by MADAO on 16/11/4.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBaseRoundButton.h"

@interface HBBaseRoundButton()

/**
 按钮点击回调
 */
@property (nonatomic, copy) void(^buttonClickBlock)();

/**
 按钮图标
 */
@property (nonatomic, strong, readwrite) UIImageView *iconView;

/**
 按钮图片
 */
@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, weak) CAShapeLayer *maskLayer;

@end

//icon大小
CGFloat const kHBRoundButtonContentInsets = 10.f;

@implementation HBBaseRoundButton

- (instancetype)initWithIconImage:(UIImage *)image clickBlock:(void(^)())block {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, 50, 50);
        self.buttonClickBlock = block;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.iconImage = image;
        [self addTarget:self action:@selector(handleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置背景色
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

/**
 设置子视图
 */
- (void)setupSubViews {
    self.iconView = [[UIImageView alloc] initWithImage:self.iconImage];
    [self addSubview:self.iconView];
    @WEAKSELF;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).with.offset(kHBRoundButtonContentInsets);
        make.right.bottom.equalTo(weakSelf).with.offset(-kHBRoundButtonContentInsets);
    }];
}

- (void)setupMaskLayer {
    [self layoutIfNeeded];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.8;
    self.layer.cornerRadius = self.bounds.size.width/2.f;
}

#pragma mark - ButtonAction
- (void)handleButtonOnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
}

#pragma mark - LifeCycle
- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setupMaskLayer];
}

@end
