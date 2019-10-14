//
//  ViewController.m
//  AutoArchive
//
//  Created by Black on 2019/10/9.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "ViewController.h"
#import "ly_helperFile.h"

#ifdef DEBUG
#define BaseURL @"123"
#else
#define BaseURL @"456"
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([BaseURL isEqualToString:@"123"]){
        self.view.backgroundColor = [UIColor redColor];
    }else if ([BaseURL isEqualToString:@"456"]){
        self.view.backgroundColor = [UIColor yellowColor];
    }else{
        self.view.backgroundColor = [UIColor purpleColor];
    }
    [UIApplication sharedApplication].statusBarHidden = YES;
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    
    
    NSLog(@"frame:%@",NSStringFromCGRect(frame));
    NSLog(@"-----------------------------------");
    NSLog(@"safeArea:%@",NSStringFromUIEdgeInsets(kSafeArea));
}




- (UIEdgeInsets)deviceSafeArea{
    
    // 状态栏状态
    BOOL showBar =  [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden = YES;
    // 状态栏尺寸
    CGRect barFrame = [UIApplication sharedApplication].statusBarFrame;
    [UIApplication sharedApplication].statusBarHidden = showBar;
    // 返回安全区域
    CGFloat top    = CGRectGetHeight(barFrame);
    CGFloat bottom = (top > 20)?39:0;
    return UIEdgeInsetsMake(top, 0, bottom, 0);
}


@end
