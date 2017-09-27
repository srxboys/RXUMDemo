//
//  RXScreenshotView.m
//  RXUMDemo
//
//  Created by srx on 2017/9/27.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXScreenshotView.h"

@implementation RXScreenshotView

+ (RXScreenshotView *)defaultScreenshot {
    static RXScreenshotView * _screenshot = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenshot = [[RXScreenshotView alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_screenshot selector:@selector(screenshotStart) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    });
    return _screenshot;
}

- (void)screenshotStart {
    
    NSString * imgPath = [[NSBundle mainBundle] pathForResource:@"srxboys" ofType:@"png"];
    UIImage * img = [UIImage imageWithContentsOfFile:imgPath];
    UIImage * image = [self imageWithWatermarkImage:img];
    
    UIImage * textImage = [self imageWithTextImage:@"@srxboys"];
    
    if(_ScreenshotBlock) {
        _ScreenshotBlock(image, textImage);
    }
}

/** 给截屏图片添加图片水印 */
- (UIImage *) imageWithWatermarkImage:(UIImage *)image {
    UIImage * screenshotImage = [self imageWithScreenshot];
    
    CGSize screenshotSize = screenshotImage.size;
    CGSize imageSize = image.size;
    
    CGRect frame = CGRectZero;
    CGFloat x = screenshotSize.width - (lroundf(imageSize.width) % lroundf(screenshotSize.width));
    if(x > 20) {
        x -= 20;
    }
    
    CGFloat y = screenshotSize.height - (lroundf(imageSize.height) % lroundf(screenshotSize.height));
    if(y > 20) {
        y -= 20;
    }
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = lroundf(imageSize.width) % lroundf(screenshotSize.width);
    frame.size.height = lroundf(imageSize.height) % lroundf(screenshotSize.height);
    
    //opaque YES不透明 NO透明
    UIGraphicsBeginImageContextWithOptions(screenshotSize, NO, 0.0);
    //截图的图片作为底图
    [screenshotImage drawAtPoint:CGPointZero];
    
    //添加水印图片
    [image drawInRect:frame];
    
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/** 给截屏图片添加文字水印 */
- (UIImage *) imageWithTextImage:(NSString *)text {
    UIImage * screenshotImage = [self imageWithScreenshot];
    
    CGSize screenshotSize = screenshotImage.size;
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(text == nil) {
        text = @"";
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    
    NSMutableAttributedString * textAttri = [[NSMutableAttributedString alloc] initWithString:text];
    [textAttri addAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:60], NSForegroundColorAttributeName: [UIColor whiteColor], NSStrokeColorAttributeName:[UIColor darkGrayColor],NSStrokeWidthAttributeName: @(3)} range:NSMakeRange(0, textAttri.length)];
    
    CGSize textSize = [textAttri boundingRectWithSize:CGSizeMake(screenshotSize.width - 20, screenshotSize.height - 20) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGRect frame = CGRectZero;
    frame.size = textSize;
    
    CGFloat x = screenshotSize.width - textSize.width;
    if(x > 20) {
        x -= 20;
    }
    
    CGFloat y = screenshotSize.height - textSize.height;
    if(y > 20) {
        y -= 20;
    }
    frame.origin.x = x;
    frame.origin.y = y;
    
    //opaque YES不透明 NO透明
    UIGraphicsBeginImageContextWithOptions(screenshotSize, NO, 0.0);
    //截图的图片作为底图
    [screenshotImage drawAtPoint:CGPointZero];
    
    //添加水印文字
    [textAttri drawInRect:frame];
    
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/** 获取截屏图片 */
- (UIImage *)imageWithScreenshot {
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
    
}

/** 截屏 */
- (NSData *)dataWithScreenshotInPNGFormat {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
        {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
            {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
            }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
            {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
            }
        else
            {
            [window.layer renderInContext:context];
            }
        CGContextRestoreGState(context);
        }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
