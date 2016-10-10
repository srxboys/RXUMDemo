//
//  RXOpenURL.m
//  RXUMDemo
//
//  Created by srx on 16/10/10.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXOpenURL.h"
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>
#import "Header.h"

//#import <AlipaySDK/AlipaySDK.h>
//#import "DataVerifier.h"
//#import "AlixPayResult.h"
//#import "UPPaymentControl.h"

#import <UMSocialCore/UMSocialCore.h>


@interface RXOpenURL ()<WXApiDelegate>

@property (nonatomic, copy) NSURL * wxOpenUrl;

@end


@implementation RXOpenURL
+ (instancetype)defaultAppOpenURL {
    static RXOpenURL * _app = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _app = [[RXOpenURL alloc] init];
    });
    return _app;
}

+ (void)openURL:(NSURL *)url {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenUrl_notifaction object:nil];
    
    NSString *urlStr = [url absoluteString];
    
    NSString * sinaStr = [NSString stringWithFormat:@"wb%@",SINA_APPKEY];
    if ([urlStr hasPrefix:sinaStr] || [urlStr hasSuffix:@"//platformId=wechat"]) {
        
        [[UMSocialManager defaultManager] handleOpenURL:url];
        return ;
    }
    
    if ([urlStr hasPrefix:WXAPPID] )
    {
        [RXOpenURL defaultAppOpenURL].wxOpenUrl = url;
        [WXApi handleOpenURL:url delegate:[RXOpenURL defaultAppOpenURL]];
        
        return;
    }
    
    //    if ([url.host isEqualToString:@"safepay"]) {
    //
    //        //跳转支付宝钱包进行支付，处理支付结果
    //        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    //            TTLog(@"result = %@",resultDic);
    //            NSString *resultString = [GHSAppOpenURL dictionaryToJsons:resultDic];
    //            AlixPayResult *payResult = [[AlixPayResult alloc] initWithString:resultString];
    //            if (payResult.statusCode == 9000) {
    //                ////支付成功
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayPaySuccess" object:nil];
    //            }else{
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayPayFail" object:nil];
    //            }
    //        }];
    //        return;
    //    }
    //
    //    ///银联支付回调
    //    [self UPPResult:url];
    
}

+ (NSString*)dictionaryToJsons:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/////银联支付回调
//+ (void)UPPResult:(NSURL *)url{
//    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
//
//        if ([code isEqualToString:@"success"]) {
//            if (data == nil) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUPPResult object:@"0"];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUPPResult object:@"1"];
//            }
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUPPResult object:@"0"];
//        }
//    }];
//}

//微信 回调
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                //                TTLog(@"支付成功");
                //                TTLog(@"支付成功");
                //                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeChatPayResult object:@"1"];
            }
                break;
            default:{
                //                TTLog(@"支付失败，retcode=%d",resp.errCode);
                //                TTLog(@"支付失败，retcode=%d",resp.errCode);
                //                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeChatPayResult object:@"0"];
            }
                break;
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]]) {
        //微信认证
        [[UMSocialManager defaultManager] handleOpenURL:_wxOpenUrl];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
