//
//  AppDelegate.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/5.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "AppDelegate.h"
#import "FPSIndicatorMgr.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[FPSIndicatorMgr sharedFPSIndicator] show];
    
    return YES;
}

@end
