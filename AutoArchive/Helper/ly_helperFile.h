//
//  ly_helperFile.h
//  AutoArchive
//
//  Created by Black on 2019/10/14.
//  Copyright © 2019 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**************帮助文件宏******************/
#define kSafeArea  [ly_helperFile safeArea]


/************帮助文件内容部分****************/
@interface ly_helperFile: NSObject

// 设备安全区域
+ (UIEdgeInsets)safeArea;

@end

