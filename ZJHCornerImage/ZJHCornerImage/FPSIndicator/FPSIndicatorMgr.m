//
//  FPSIndicatorMgr.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/12.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "FPSIndicatorMgr.h"
#import "FPSIndicatorWindow.h"

@interface FPSIndicatorMgr() {
    CADisplayLink *_displayLink;
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

@property (nonatomic, strong) FPSIndicatorWindow *fpsWindow;

@end

@implementation FPSIndicatorMgr

+ (FPSIndicatorMgr *)sharedFPSIndicator {
    static dispatch_once_t onceToken;
    static FPSIndicatorMgr *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[FPSIndicatorMgr alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

// 创建CADisplayLink
- (void)initConfig {    
    // create fpsWindow
    _fpsWindow = [FPSIndicatorWindow getWindow];
    
    // 创建CADisplayLink，并添加到当前run loop的NSRunLoopCommonModes
    _displayLink = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(p_displayLinkTick:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
}

// 计算 fps
- (void)p_displayLinkTick:(CADisplayLink *)link {
    // 当前时间戳
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++; // 执行次数
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) {
        return;
    }
    _lastTime = link.timestamp;
    float fps = _count / delta; // fps
    _count = 0;
    
    // 更新fps
    [_fpsWindow updateFps:fps];
}

- (void)show {
    self.fpsWindow.hidden = NO;
}

- (void)hide {
    self.fpsWindow.hidden = YES;
}

@end
