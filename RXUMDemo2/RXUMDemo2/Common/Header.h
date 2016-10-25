//
//  Header.h
//  RXUMDemo2
//
//  Created by srx on 2016/10/25.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define GHS_666_COLOR    UIColorRGB(102, 102, 102)
#define GHS_333_COLOR    UIColorRGB(51 , 51 , 51 )

#pragma mark ---- 宽 高 定义 --------
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


//iOS 屏幕大小
#pragma mark ---- iOS 屏幕大小 定义 --------
#define iPhone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size) ? YES : NO)
#define iPhone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size) ? YES : NO)
#define iPhone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size) ? YES : NO)
#define iPhone6Plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size) ? YES : NO)


#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#pragma mark ---- iOS 版本 定义 --------
//操作系统版本
#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion

//大于多少版本
#define iOS7OrLater ([SYSTEMVERSION floatValue] >= 7.0)
#define iOS8OrLater ([SYSTEMVERSION floatValue] >= 8.0)
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)


#endif /* Header_h */
