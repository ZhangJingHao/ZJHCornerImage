//
//  UIImageView+Circle.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/14.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "UIImageView+Circle.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static char LoadingImageUrlStrKey, CancelLoadingArrKey;

@implementation UIImageView (Circle)

- (NSString *)loadingImageUrlStr {
    return objc_getAssociatedObject(self, &LoadingImageUrlStrKey);
}

- (void)setLoadingImageUrlStr:(NSString *)loadingUrlStr {
    [self willChangeValueForKey:@"LoadingImageUrlStrKey"];
    objc_setAssociatedObject(self,
                             &LoadingImageUrlStrKey,
                             loadingUrlStr,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingImageUrlStrKey"];
}

- (NSMutableArray *)cancelLoadingArr {
    NSMutableArray *arr = objc_getAssociatedObject(self, &CancelLoadingArrKey);
    if (!arr) {
        arr = [NSMutableArray array];
        [self setCancelLoadingArr:arr];
    }
    return arr;
}

- (NSString *)keyWithImageUrl:(NSURL *)url {
    NSString *imgStr = url.absoluteString;
    NSString *imgkey = [NSString stringWithFormat:@"circle_%@", imgStr];
    return imgkey;
}

- (void)setCancelLoadingArr:(NSMutableArray *)arr {
    [self willChangeValueForKey:@"CancelLoadingArrKey"];
    objc_setAssociatedObject(self,
                             &CancelLoadingArrKey,
                             arr,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"CancelLoadingArrKey"];
}


- (void)circleImageWithUrl:(NSURL *)imgUrl
               placeholder:(UIImage *)placeholder
                      rate:(CGFloat)rate {
    NSString *imgkey = [self keyWithImageUrl:imgUrl];
    UIImage *circleImg = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgkey];
    if (circleImg) {
        self.image = circleImg;
        return;
    }
    
    if (self.loadingImageUrlStr) {
        // 取消上一个图片绘制
        [self.cancelLoadingArr addObject:self.loadingImageUrlStr];
    }
    
    __weak typeof(self)wkSlef = self;
    [self sd_setImageWithURL:imgUrl
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       [wkSlef backgroundDrawImageForImage:image
                                            cacheWithUrl:imageURL
                                                    rate:rate];
                   }];
}

- (void)backgroundDrawImageForImage:(UIImage *)image
                       cacheWithUrl:(NSURL *)imgUrl
                               rate:(CGFloat)rate {
    [self setLoadingImageUrlStr:imgUrl.absoluteString];
    
    __weak typeof(self)wkSlef = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
        CGRect roundRect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGFloat radius = image.size.width * rate;
        [[UIBezierPath bezierPathWithRoundedRect:roundRect
                                    cornerRadius:radius] addClip];
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        UIImage *radiusImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SDImageCache sharedImageCache] storeImage:radiusImg
                                                 forKey:[wkSlef keyWithImageUrl:imgUrl]
                                             completion:nil];
            if ([wkSlef.cancelLoadingArr containsObject:imgUrl.absoluteString]) {
                [wkSlef.cancelLoadingArr removeObject:imgUrl.absoluteString];
            } else {
                wkSlef.image = radiusImg;
            }
        });
    });
    
}

@end

