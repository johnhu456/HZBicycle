//
//  HBBicycleAnnotationView.m
//  HZBicycle
//
//  Created by MADAO on 16/11/1.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleAnnotationView.h"

@interface HBBicycleAnnotationView()

/**
 自定义气泡
 */
@property (nonatomic, strong, readwrite) HBBicyclePopView *popView;

@end

#warning todo 
static CGFloat const kPopViewHeight = 60.f;
static CGFloat const kPopViewWidth = 150.f;
static CGFloat const kContentInsets = 15.f;

@implementation HBBicycleAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.image = ImageInName(@"main_bicycle");
        self.canShowCallout   = NO;
        self.draggable        = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.popView ==nil ) {
            self.popView = [[HBBicyclePopView alloc] initWithFrame:CGRectMake(0, 0, kPopViewWidth, kPopViewHeight)];
            [self addSubview:self.popView];
        }
    }else {
        [self.popView removeFromSuperview];
        self.popView = nil;
    }
    if ([self.annotation isKindOfClass:[HBBicyclePointAnnotation class]]) {
        HBBicyclePointAnnotation *annotion = (HBBicyclePointAnnotation *)self.annotation;
        [self.popView setStationModel:annotion.station];
        [self autoAdjustFrame];
    }
    [super setSelected:selected animated:animated];
}

#pragma mark - Private Method
- (void)autoAdjustFrame {
    if ([self.annotation isKindOfClass:[HBBicyclePointAnnotation class]]) {
        HBBicyclePointAnnotation *annotion = (HBBicyclePointAnnotation *)self.annotation;
        [self.popView setStationModel:annotion.station];
        NSString *title = [annotion.station.name stringByAppendingFormat:@"(编号：%ld)",annotion.station.number];
        CGSize titleSize = [title sizeWithAttributes:@{
                                                       NSFontAttributeName : HB_FONT_LIGHT_SIZE(14)
                                                       }];
        self.calloutOffset = CGPointMake(- titleSize.width/2.f , -kPopViewHeight - 20.f);
        self.popView.frame = CGRectMake(self.popView.frame.origin.x + self.calloutOffset.x + 2 * kContentInsets, self.popView.frame.origin.y + self.calloutOffset.y, titleSize.width, kPopViewHeight);
    }
}

- (void)drawRect:(CGRect)rect {
    
}

@end
