//
//  RXScreenshotView.h
//  RXUMDemo
//
//  Created by srx on 2017/9/27.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScreenshotStart)(UIImage * image, UIImage * txtImage);

@interface RXScreenshotView : UIView
+ (RXScreenshotView *)defaultScreenshot;
@property (nonatomic, copy) ScreenshotStart ScreenshotBlock;
- (void)screenshotStart;
@end


/** 根据自己的喜好，去封装吧 */
