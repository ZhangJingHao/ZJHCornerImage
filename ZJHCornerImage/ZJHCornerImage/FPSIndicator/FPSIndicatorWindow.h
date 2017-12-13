//
//  FPSIndicatorWindow.h
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/12.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPSIndicatorWindow : UIWindow

+ (FPSIndicatorWindow *)getWindow;

- (void)updateFps:(float)fps;

@end
