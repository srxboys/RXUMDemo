//
//  ViewController.m
//  RXUMDemo
//
//  Created by srx on 16/10/10.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "ViewController.h"
#import "RXUMSDK.h"
#import "RXScreenshotView.h"

#import "RXScreenshotDetailViewController.h"

#define imageURL @"http://ws2.cdn.caijing.com.cn/2013-12-06/113659890.jpg"

@interface ViewController ()
{
    RXUMSDK  * _shareView;
    
    RXScreenshotView * ssView;
    UIImage * _screenshotImage;
    UIImage * _screenshotTxtImage;
}
- (IBAction)shareButtonClick:(id)sender;
- (IBAction)wxLoginButtonClick:(id)sender;
- (IBAction)wbButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *screenshotButton;

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)object {
    if([segue.identifier compare:@"second"] == NO) {
        id page2 = segue.destinationViewController;
        [page2 setValue:_screenshotImage forKey:@"image"];
        [page2 setValue:_screenshotTxtImage forKey:@"textImage"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shareView = [[RXUMSDK alloc] init];
    [self.view addSubview:_shareView];
    
    ssView = [RXScreenshotView defaultScreenshot];
    __weak typeof(self)weakSelf = self;
    ssView.ScreenshotBlock = ^(UIImage *image, UIImage *txtImage) {
        weakSelf.screenshotButton.enabled = NO;
        if(image||txtImage) {
            _screenshotImage = image;
            _screenshotTxtImage = txtImage;
            weakSelf.screenshotButton.enabled = YES;
        }
    };

#if TARGET_IPHONE_SIMULATOR
    /// 模拟器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ssView screenshotStart];
    });
#endif
}


- (IBAction)shareButtonClick:(id)sender {
    
    [_shareView showShareWithViewController:self type:ShareTypeSku title:@"欧哥斯家用制氧机" content:@"好消息" resourceId:@"9113767" image:imageURL completion:^(NSString *result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (IBAction)wxLoginButtonClick:(id)sender {
    [_shareView showLoginWithViewController:self  loginType:LoginTypeWX completion:^(UMSocialUserInfoResponse *snsAccount, NSString *errorString) {
        
        NSString *message = [NSString stringWithFormat:@"result: %@\n uid: %@\n accessToken: %@\n",errorString,snsAccount.uid,snsAccount.name];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wx Login"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)wbButtonClick:(id)sender {
    [_shareView showLoginWithViewController:self  loginType:LoginTypeSina completion:^(UMSocialUserInfoResponse *snsAccount, NSString *errorString) {
        
        
        NSString *message = [NSString stringWithFormat:@"result: %@\n uid: %@\n accessToken: %@\n",errorString,snsAccount.uid,snsAccount.name];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wbb Login"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
