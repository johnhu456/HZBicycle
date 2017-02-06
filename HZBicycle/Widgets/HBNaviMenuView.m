//
//  HBNaviMenuView.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/7.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBNaviMenuView.h"

@interface  HBNaviMenuView()

/**
 目的地标签
 */
@property (nonatomic, strong) UILabel *lblDestination;

/**
 地址标签
 */
@property (nonatomic, strong) UILabel *lblAdress;

/**
 距离标签
 */
@property (nonatomic, strong) UILabel *lblDistance;

/**
 时间标签
 */
@property (nonatomic, strong) UILabel *lblTime;

/**
 开始导航按钮
 */
@property (nonatomic, strong) UIButton *btnStartNavi;

/**
 加载指示器
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSMutableAttributedString *selectedTitle; //Weak不好用

@property (nonatomic, strong) NSMutableAttributedString *normalTitle;

/**
 按钮回调
 */
@property (nonatomic, copy) void(^buttonClicked)(UIButton *sender);

@end

#pragma mark - Constant
static CGFloat const kHeight = 170.f; //目的地标签高度
static CGFloat const kHeightDestination = 16.f; //目的地标签高度
static CGFloat const kWidthButton = 200.f;      //按钮宽度
static CGFloat const kHeightButton = 50.f;      //按钮高度
static CGFloat const kHeightDistance = 18.f;    //距离标签高度
static CGFloat const kInsetsNormal = 10.f;      //上下边距
static CGFloat const kInsetsLeft = 15.f;        //左右边距
static NSUInteger const kHoursInSeconds = 3600; //一小时秒数

static NSString *const kTitleStartNavi = @"开始导航";        //导航按钮提示
static NSString *const kTitleRetry = @"重试";               //重试提示

@implementation HBNaviMenuView
#pragma mark - Lazy Init
- (NSMutableAttributedString *)selectedTitle {
    if (_selectedTitle == nil) {
        NSTextAttachment *retryAttachment = [[NSTextAttachment alloc] init];
        retryAttachment.image = ImageInName(@"navi_menu_retry");
        retryAttachment.bounds = CGRectMake(0, -6, 30.f, 30.f);
        NSMutableAttributedString *retryAttachString = [[NSAttributedString attributedStringWithAttachment:retryAttachment] mutableCopy];
        NSAttributedString *retryTitle = [[NSMutableAttributedString alloc] initWithString:kTitleRetry attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : HB_FONT_LIGHT_SIZE(25)}];
        [retryAttachString appendAttributedString:retryTitle];
        _selectedTitle = retryAttachString;
    }
    return _selectedTitle;
}

- (NSMutableAttributedString *)normalTitle {
    if (_normalTitle == nil) {
        NSTextAttachment *naviAttachment = [[NSTextAttachment alloc] init];
        naviAttachment.image = ImageInName(@"navi_menu_navi");
        naviAttachment.bounds = CGRectMake(0, -6, 30.f, 30.f);
        NSMutableAttributedString *naviAttachString = [[NSAttributedString attributedStringWithAttachment:naviAttachment] mutableCopy];
        NSAttributedString *naviStartTitle = [[NSMutableAttributedString alloc] initWithString:kTitleStartNavi attributes:@{NSForegroundColorAttributeName : HB_COLOR_DARKBLUE,NSFontAttributeName : HB_FONT_LIGHT_SIZE(25)}];
        [naviAttachString appendAttributedString:naviStartTitle];
        _normalTitle = naviAttachString;
    }
    return _normalTitle;
}

#pragma mark - Initialize
- (instancetype)init {
    [[NSException exceptionWithName:@"Initialize Error" reason:@"Use initWithButtonClick: instead" userInfo:nil] raise];
    return nil;
}

- (instancetype)initWithButtonClick:(void (^)(UIButton *))block {
    if (self = [super init]) {
        self.backgroundColor = HB_COLOR_DARKBLUE;
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeight);
        [self setupSubViews];
        [self setupCorners];
        self.buttonClicked = block;
    }
    return self;
}

- (void)setupSubViews {
    self.lblDestination = [[UILabel alloc] init];
    self.lblDestination.textAlignment = NSTextAlignmentCenter;
    self.lblDestination.adjustsFontSizeToFitWidth = YES;
    self.lblDestination.font = HB_FONT_MEDIUM_SIZE(16);
    self.lblDestination.textColor = [UIColor whiteColor];
    [self addSubview:self.lblDestination];
    
    self.lblDistance = [[UILabel alloc] init];
    self.lblDistance.textAlignment = NSTextAlignmentCenter;
    self.lblDistance.font = HB_FONT_MEDIUM_SIZE(18);
    self.lblDistance.textColor = [UIColor whiteColor];
    [self addSubview:self.lblDistance];
    
    self.lblAdress = [[UILabel alloc] init];
    self.lblAdress.textAlignment = NSTextAlignmentCenter;
    self.lblAdress.adjustsFontSizeToFitWidth = YES;
    self.lblAdress.font = HB_FONT_LIGHT_SIZE(14);
    self.lblAdress.textColor = [UIColor whiteColor];
    [self addSubview:self.lblAdress];
    
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.textAlignment = NSTextAlignmentCenter;
    self.lblTime.font = HB_FONT_MEDIUM_SIZE(18);
    self.lblTime.textColor = [UIColor whiteColor];
    [self addSubview:self.lblTime];
    
    self.btnStartNavi = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnStartNavi fh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnStartNavi fh_setBackgroundColor:[UIColor colorWithRed:0.6409 green:0.3155 blue:0.3177 alpha:1] forState:UIControlStateSelected];
    [self.btnStartNavi addTarget:self action:@selector(handleHeightState:) forControlEvents:UIControlEventTouchDown];
    [self.btnStartNavi addTarget:self action:@selector(handleNaviButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnStartNavi.layer.cornerRadius = 5.f;
    self.btnStartNavi.layer.masksToBounds = YES;
    [self addSubview:self.btnStartNavi];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView startAnimating];
    self.indicatorView.userInteractionEnabled = NO;
    self.indicatorView.hidden = YES;
    [self.btnStartNavi addSubview:self.indicatorView];
    //约束
    [self makeConstraints];
    //设置按钮标题
    [self setupButtonTitle];
}

- (void)setupCorners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)makeConstraints {
    @WEAKSELF;
    [self.lblDestination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(kInsetsNormal);
        make.left.equalTo(weakSelf.mas_left).with.offset(kInsetsLeft);
        make.right.equalTo(weakSelf.mas_right).with.offset(-kInsetsLeft);
        make.height.mas_equalTo(kHeightDestination);
    }];
    
    [self.lblAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.lblDestination);
        make.height.mas_equalTo(kHeightDistance);
        make.top.equalTo(weakSelf.lblDestination.mas_bottom).with.offset(kInsetsNormal);
    }];
    
    [self.lblDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblDestination);
        make.right.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(kHeightDistance);
        make.top.equalTo(weakSelf.lblAdress.mas_bottom).with.offset(kInsetsLeft);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.height.equalTo(weakSelf.lblDistance);
        make.right.equalTo(weakSelf.lblDestination);
    }];
    
    [self.btnStartNavi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(kWidthButton);
        make.height.mas_equalTo(kHeightButton);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-kInsetsLeft);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(weakSelf.btnStartNavi);
        make.width.height.mas_equalTo(30.f);
    }];
}

#pragma mark - Setter

- (void)setRoute:(AMapNaviRoute *)route {
    _route = route;
    self.lblDistance.text = [self getDistanceDescriptionWithLength:_route.routeLength];
    self.lblTime.text = [self getTimeDescriptionWithSecond:_route.routeTime];
}

- (void)setStation:(HBBicycleStationModel *)station {
    _station = station;
    self.lblDestination.text = _station.name;
    self.lblAdress.text = _station.address;
}


#pragma mark - Public Method
- (void)startLoading {
    [self.btnStartNavi setAttributedTitle:[[NSAttributedString alloc] initWithString:@" "] forState:UIControlStateSelected];
    [self.btnStartNavi setAttributedTitle:[[NSAttributedString alloc] initWithString:@" "] forState:UIControlStateNormal];
    self.btnStartNavi.selected = YES;
    self.indicatorView.hidden = NO;
    self.btnStartNavi.enabled = NO;
}

- (void)endLoadingWithSuccess:(BOOL)success {
    [self setupButtonTitle];
    self.btnStartNavi.selected = !success;
    self.btnStartNavi.enabled = YES;
    self.indicatorView.hidden = YES;
    if (!success) {
        //设置数据显示
#warning has space to improve
        self.lblDistance.text = @"";
        self.lblTime.text = @"";
    }
}

#pragma mark - Private Method

- (void)setupButtonTitle {
    [self.btnStartNavi setAttributedTitle:self.normalTitle forState:UIControlStateNormal];
    [self.btnStartNavi setAttributedTitle:self.selectedTitle forState:UIControlStateSelected];
    [self.btnStartNavi setAttributedTitle:[[NSAttributedString alloc] initWithString:@" "] forState:UIControlStateHighlighted];
}

- (NSString *)getDistanceDescriptionWithLength:(NSInteger)length {
    //适配单位
    if (length>100) {
        return [NSString stringWithFormat:@"距您：%.1f公里",length/1000.f];
    }else {
        return [NSString stringWithFormat:@"距您：%ld米",(long)length];
    }
}

- (NSString *)getTimeDescriptionWithSecond:(NSInteger)second {
    if (second < kHoursInSeconds) {
        return [NSString stringWithFormat:@"预计需要：%d分",(int)(second/60.f)];
    } else {
        return [NSString stringWithFormat:@"预计需要：%.1f时",(CGFloat)(second/kHoursInSeconds)/1.f];
    }
}

- (void)handleHeightState:(UIButton *)sender {
    if (sender.selected) {
        //MARK:Have to do this maybe has another way,like GCD;
        [self.btnStartNavi setAttributedTitle:[[NSAttributedString alloc] initWithString:@" "] forState:UIControlStateNormal];
        self.btnStartNavi.highlighted = YES;
    }
}

- (void)handleNaviButtonOnClicked:(UIButton *)sender {
    if (sender.selected) {
        //显示加载
        [self startLoading];
    }else {
        [self endLoadingWithSuccess:YES];
    }
    //执行block
    if (self.buttonClicked) {
        self.buttonClicked(sender);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
