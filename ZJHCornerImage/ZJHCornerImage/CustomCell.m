//
//  CustomCell.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/7.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Circle.h"

@interface CustomCell ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLab;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) int method;

@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGFloat upH = height - width;
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, upH)];
    [self addSubview:upView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, upH, width, 0.3)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    [self addSubview:lineView];
    
    CGFloat iconXY = upH * 0.15;
    CGFloat iconWH = upH - iconXY * 2;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconXY, iconXY, iconWH, iconWH)];
    [upView addSubview:iconView];
    self.iconView = iconView;
    
    CGFloat nameX = iconXY * 2 + iconWH;
    CGFloat nameW = width - nameX - iconXY;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 0, nameW, upH)];
    nameLab.font = [UIFont systemFontOfSize:14.0/36 * upH];
    [upView addSubview:nameLab];
    self.nameLab = nameLab;
    
    CGFloat imgX = width * 0.06;
    CGFloat imgY = upH + imgX;
    CGFloat imgWH = width - imgX * 2;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    [self addSubview:imgView];
    self.imgView = imgView;
    
    NSString *classStr = NSStringFromClass(self.class);
    if ([classStr isEqualToString:@"CornerRadiusCell"]) {
        self.method = 1; // 方式1
    } else if ([classStr isEqualToString:@"CoreGraphicsCell"]) {
        self.method = 2; // 方式2
    } else if ([classStr isEqualToString:@"ShapeLayerCell"]) {
        self.method = 3; // 方式3
    } else if ([classStr isEqualToString:@"CoverViewCell"]) {
        self.method = 4; // 方式4
    } else if ([classStr isEqualToString:@"SDGraphicsCell"]) {
        self.method = 5; // 方式5
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL m = NSSelectorFromString([NSString stringWithFormat:@"method%d",self.method]);
    [self performSelector:m];
#pragma clang diagnostic pop
}

- (void)bindModel:(id)model {
    self.nameLab.text = model[@"user"][@"name"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL m = NSSelectorFromString([NSString stringWithFormat:@"method%d_bindmodel:",self.method]);
    [self performSelector:m withObject:model];
#pragma clang diagnostic pop
}

#pragma mark - 方式1：通过 CornerRadius 设置圆角

- (void)method1 {
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height / 2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.shadowOffset = CGSizeMake(0, 5);
    self.iconView.layer.shadowOpacity = 1;
    
    self.imgView.layer.cornerRadius = 10;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.shadowOffset = CGSizeMake(0, 5);
    self.imgView.layer.shadowOpacity = 1;
}
- (void)method1_bindmodel:(id)model {
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    NSURL *iconUrl = [NSURL URLWithString:model[@"user"][@"avatar_url"]];
    [self.iconView sd_setImageWithURL:iconUrl placeholderImage:placeholder];
    
    NSURL *imgUrl = [NSURL URLWithString:model[@"images"][@"normal"]];
    [self.imgView sd_setImageWithURL:imgUrl placeholderImage:placeholder];
}

#pragma mark - 方式2：通过 Core Graphics 生成圆角图片

- (void)method2 {
    
}
- (void)method2_bindmodel:(id)model {
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    NSURL *iconUrl = [NSURL URLWithString:model[@"user"][@"avatar_url"]];
    __weak typeof(self) wkSlef = self;
    [self.iconView sd_setImageWithURL:iconUrl
                     placeholderImage:[self radiusImageWithImage:placeholder withRadius:0]
                            completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                wkSlef.iconView.image = [wkSlef radiusImageWithImage:image
                                                                          withRadius:0];
                            }];
    
    NSURL *imgUrl = [NSURL URLWithString:model[@"images"][@"normal"]];
    [self.imgView sd_setImageWithURL:imgUrl
                     placeholderImage:[self radiusImageWithImage:placeholder withRadius:10]
                            completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                wkSlef.imgView.image = [wkSlef radiusImageWithImage:image
                                                                         withRadius:10];
                            }];
}

- (UIImage *)radiusImageWithImage:(UIImage *)image withRadius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGRect roundRect = CGRectMake(0, 0, image.size.width, image.size.height);
    if (!radius) {
        radius = image.size.width / 2.0;
    }
    [[UIBezierPath bezierPathWithRoundedRect:roundRect
                                cornerRadius:radius] addClip];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *radiusImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return radiusImg;
}

#pragma mark - 方式3：通过 UIBezierPath CAShapeLayer 绘制控件圆角

- (void)method3 {
    [self circleViewWithView:self.iconView radius:self.iconView.frame.size.width / 2];
    [self circleViewWithView:self.imgView radius:10];
}
- (void)method3_bindmodel:(id)model {
    [self method1_bindmodel:model];
}
- (void)circleViewWithView:(UIView *)view radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                        cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 方式4：覆盖镂空图片

- (void)method4 {
    UIImageView *iconCover= [[UIImageView alloc] initWithFrame:self.iconView.frame];
    iconCover.image = [UIImage imageNamed:@"imageCornerCover"];
    [self addSubview:iconCover];
    
    UIImageView *imgCover = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    imgCover.image = [UIImage imageNamed:@"imageCornerCover"];
    [self addSubview:imgCover];
}
- (void)method4_bindmodel:(id)model {
    [self method1_bindmodel:model];
}

#pragma mark - 方式5：SDWebImage + Graphics

- (void)method5 {
    
}
- (void)method5_bindmodel:(id)model {
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    NSURL *iconUrl = [NSURL URLWithString:model[@"user"][@"avatar_url"]];
    [self.iconView circleImageWithUrl:iconUrl
                          placeholder:placeholder
                                 rate:0.5];
    
    NSURL *imgUrl = [NSURL URLWithString:model[@"images"][@"normal"]];
    [self.imgView circleImageWithUrl:imgUrl
                         placeholder:placeholder
                                rate:0.1];
}

@end
