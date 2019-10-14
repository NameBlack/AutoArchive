//
//  ly_helperFile.m
//  AutoArchive
//
//  Created by Black on 2019/10/14.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "ly_helperFile.h"

@implementation ly_helperFile


// 设备安全区域
+ (UIEdgeInsets)safeArea{
    
    // 状态栏状态
    BOOL showBar =  [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 状态栏尺寸
    CGRect barFrame = [UIApplication sharedApplication].statusBarFrame;
    [UIApplication sharedApplication].statusBarHidden = showBar;
    // 返回安全区域
    CGFloat top    = CGRectGetHeight(barFrame);
    CGFloat bottom = (top > 20)?39:0;
    return UIEdgeInsetsMake(top, 0, bottom, 0);
}

@end
