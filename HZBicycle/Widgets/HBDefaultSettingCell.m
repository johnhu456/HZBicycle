//
//  HBOfficialContactCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/17.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBDefaultSettingCell.h"

@interface HBDefaultSettingCell(){
    HBSettintCellType _type;
    NSString *_title;
    UIImage *_icon;
}

/**
 背景View
 */
@property (nonatomic, strong) UIView *backView;

/**
 标题标签
 */
@property (nonatomic, strong) UILabel *lblTitle;

/**
 图标
 */
@property (nonatomic, strong) UIImageView *iconView;

@end

#pragma mark - Constant
static CGFloat const kDefaultInsets = 10.f;
static CGFloat const kTitleInsets = 15.f;
static CGFloat const kIconWidth = 30.f;

static NSString *const kReuseIdentifier = @"staticReuseIdentifier";

@implementation HBDefaultSettingCell

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)image
                     cellType:(HBSettintCellType)type
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        _icon = image;
        _type = type;
        //设置子视图
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    @WEAKSELF;
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = HB_COLOR_DARKBLUE;
    [self addSubview:self.backView];
    if (_type == HBSettintCellTypeTop) {
        //需要顶部预留空间
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf).with.offset(kDefaultInsets);
            make.right.equalTo(weakSelf).with.offset(-kDefaultInsets);
            make.bottom.equalTo(weakSelf);
        }];
    }else {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf).with.offset(kDefaultInsets);
            make.right.equalTo(weakSelf).with.offset(-kDefaultInsets);
            make.bottom.equalTo(weakSelf);
        }];
    }
    //添加白色分割线
    UIView *whiteLineView = [[UIView alloc] init];
    whiteLineView.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:whiteLineView];
    [whiteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).with.offset(kDefaultInsets);
        make.right.equalTo(weakSelf.backView).with.offset(-kDefaultInsets);
        make.bottom.equalTo(weakSelf.backView);
        make.height.mas_offset(@(1.f/[UIScreen mainScreen].scale));
    }];
    whiteLineView.hidden = _type == HBSettintCellTypeBottom;
    
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.font = HB_FONT_MEDIUM_SIZE(15);
    self.lblTitle.textAlignment = NSTextAlignmentLeft;
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.text = _title;
    [self.backView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.backView).with.offset(kTitleInsets);
        make.height.mas_equalTo(@19);
        make.right.equalTo(weakSelf.backView.mas_right).with.offset(-kTitleInsets);
    }];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.image = _icon;
    [self.backView addSubview:self.iconView];
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(kIconWidth));
        make.centerY.equalTo(weakSelf.backView);
        make.right.equalTo(weakSelf.backView.mas_right).with.offset(-kTitleInsets);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayers];
}

- (void)setupLayers {
    //设置上部圆角
    switch (_type) {
        case HBSettintCellTypeDefault:
            
            break;
        case HBSettintCellTypeTop:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.backView.bounds;
            maskLayer.path = maskPath.CGPath;
            self.backView.layer.mask = maskLayer;
        }
            break;
        case HBSettintCellTypeBottom:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.backView.bounds;
            maskLayer.path = maskPath.CGPath;
            self.backView.layer.mask = maskLayer;
        }
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
