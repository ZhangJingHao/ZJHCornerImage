//
//  FPSIndicatorWindow.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/12.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "FPSIndicatorWindow.h"

@interface FPSIndicatorWindow ()

@property (nonatomic, strong) UILabel *fpsLabel;

@end

@implementation FPSIndicatorWindow

+ (FPSIndicatorWindow *)getWindow {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat w = 55;
    CGFloat h = 20;
    CGFloat x = 15;
    CGFloat y = size.height - h - 80;
    CGRect frame = CGRectMake(x, y, w, h);
    FPSIndicatorWindow *window = [[FPSIndicatorWindow alloc] initWithFrame:frame];
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
    self.windowLevel = UIWindowLevelStatusBar + 100.0;
    self.rootViewController = [UIViewController new];
    
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
    
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier" size:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier" size:4] range:NSMakeRange(text.length - 4, 1)];
    
    _fpsLabel.attributedText = text;
}

@end
