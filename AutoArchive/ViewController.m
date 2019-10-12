//
//  ViewController.m
//  AutoArchive
//
//  Created by Black on 2019/10/9.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "ViewController.h"

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
}


@end
