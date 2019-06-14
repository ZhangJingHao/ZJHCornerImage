//
//  FPSIndicatorView.h
//  ZJHCornerImage
//
//  Created by ZhangJingHao48 on 2019/6/14.
//  Copyright © 2019 ZhangJingHao2345. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPSIndicatorView : UIView

+ (FPSIndicatorView *)getIndicatorView;

- (void)updateFps:(float)fps;

@end

NS_ASSUME_NONNULL_END
