//
//  FPSIndicatorView.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao48 on 2019/6/14.
//  Copyright © 2019 ZhangJingHao2345. All rights reserved.
//

#import "FPSIndicatorView.h"

@interface FPSIndicatorView ()

@property (nonatomic, strong) UILabel *fpsLabel;

@end

@implementation FPSIndicatorView

+ (FPSIndicatorView *)getIndicatorView {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat w = 110;
    CGFloat h = 50;
    CGFloat x = 20;
    CGFloat y = size.height - h - 100;
    CGRect frame = CGRectMake(x, y, w, h);
    FPSIndicatorView *window = [[FPSIndicatorView alloc] initWithFrame:frame];
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _fpsLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _fpsLabel.layer.cornerRadius = 5;
    _fpsLabel.clipsToBounds = YES;
    _fpsLabel.textAlignment = NSTextAlignmentCenter;
    _fpsLabel.userInteractionEnabled = NO;
    _fpsLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    [self addSubview:_fpsLabel];
}

- (void)updateFps:(float)fps {
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
    
    [text addAttribute:NSForegroundColorAttributeName value: [UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier" size:23] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier" size:6] range:NSMakeRange(text.length - 4, 1)];
    
    _fpsLabel.attributedText = text;
}

@end
