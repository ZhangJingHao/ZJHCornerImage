//
//  CustomCell.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/7.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"

@interface CustomCell ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLab;
@property (nonatomic, weak) UIImageView *imgView;

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
    iconView.layer.cornerRadius = iconWH / 2;
    iconView.layer.masksToBounds = YES;
    iconView.layer.shadowOffset = CGSizeMake(0, 5);
    iconView.layer.shadowOpacity = 1;
    
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
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
    imgView.layer.shadowOffset = CGSizeMake(0, 5);
    imgView.layer.shadowOpacity = 1;
}

- (void)bindModel:(id)model {
    self.nameLab.text = model[@"user"][@"name"];
    
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    NSURL *iconUrl = [NSURL URLWithString:model[@"user"][@"avatar_url"]];
    [self.iconView sd_setImageWithURL:iconUrl placeholderImage:placeholder];
    
    NSURL *imgUrl = [NSURL URLWithString:model[@"images"][@"normal"]];
    [self.imgView sd_setImageWithURL:imgUrl placeholderImage:placeholder];
}

// 方式一：

@end
