//
//  FPSIndicatorMgr.h
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/12.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPSIndicatorMgr : NSObject

+ (FPSIndicatorMgr *)sharedFPSIndicator;

- (void)show;

- (void)hide;

@end
