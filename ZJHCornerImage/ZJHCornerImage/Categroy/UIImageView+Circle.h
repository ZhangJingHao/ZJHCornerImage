//
//  UIImageView+Circle.h
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/14.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Circle)

/**
 设置圆角图片

 @param imgUrl 图片链接
 @param placeholder 占位图
 @param rate 圆角比率，0.5为图片宽的一半
 */
- (void)circleImageWithUrl:(NSURL *)imgUrl
               placeholder:(UIImage *)placeholder
                      rate:(CGFloat)rate;

@end
