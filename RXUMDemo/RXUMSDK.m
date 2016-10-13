//
//  RXUMSDK.m
//  RXUMDemo
//
//  Created by srx on 16/10/10.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXUMSDK.h"
#import "WXApi.h"
#import <UIView+Toast.h>
#import "Header.h"

#pragma mark --- UILabel 自适应 -----
@interface UILabel (Additions)
+ (UILabel *)foundLabelWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
@end

@implementation UILabel (Additions)

+ (UILabel *)foundLabelWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    label.textColor = color;
    return label;
}
@end

#pragma mark ----  字符串判断 ----
///判断字符串是否 为 Url
@interface NSObject (urlBOOL)
- (BOOL)urlBOOL;
@end
@implementation NSObject (urlBOOL)
- (BOOL)urlBOOL {
    if([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else if([self isKindOfClass:[NSString class]] && [(NSString *)self isEqualToString:@""]){
        return NO;
    }
    else if(![self isKindOfClass:[NSString class]]) {
        return NO;
    }
    else if ([(NSString *)self rangeOfString:@"http://"].location != NSNotFound ) {
        return YES;
    }
    else if ([(NSString *)self rangeOfString:@"https://"].location != NSNotFound ) {
        return YES;
    }
    else {
        return NO;
    }
}
@end

NSString *GHSNonEmptyString(id obj);
NSString* GHSNonEmptyString(id obj){
    if ([obj isKindOfClass:[NSString class]] && [obj length]>0 && [obj isEqualToString:@"<null>"]) {
        return @"";
    }else if (obj == nil || obj == [NSNull null] || ([obj isKindOfClass:[NSString class]] && [obj length] == 0)) {
        return @"";
    }else if ([obj isKindOfClass:[NSNumber class]] && [obj integerValue]>0)
    {
        return GHSNonEmptyString([obj stringValue]);
    }
    return obj;
}

//判断字符串是否为空
BOOL GHSIsStringWithAnyText(id object);
BOOL GHSIsStringWithAnyText(id object) {
    
    object = GHSNonEmptyString(object);
    return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}

#pragma mark ----  根据图片名称取资源 ----
UIImage* GHSImageNamed(NSString *imageName);
#define iPhone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size) ? YES : NO)

UIImage* GHSImageNamed(NSString *imageName) {
    if (iPhone5) {
        if ([[imageName lowercaseString] hasSuffix:@".png"] ||
            [[imageName lowercaseString] hasSuffix:@".jpg"] ||
            [[imageName lowercaseString] hasSuffix:@".gif"]) {
            NSString *name = [NSString stringWithFormat:@"%@-568h@2x%@",
                              [imageName substringToIndex:(imageName.length - 4)],
                              [imageName substringFromIndex:(imageName.length - 4)]];
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                return image;
            }
        }
    }
    return [UIImage imageNamed:imageName];
}
///////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark ---- 自定义分享 UIView ----
#define SERVER_URL  @"http://www.baidu.com"

#pragma mark ---- 宽 高 定义 --------
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define GHS_666_COLOR    UIColorRGB(102, 102, 102)
#define GHS_333_COLOR    UIColorRGB(51 , 51 , 51 )


#define SHARE_VIEW_height 242

typedef void(^SHARECompletion)(NSString * result);
typedef void (^BackAppBlock)(UMSocialUserInfoResponse * snsAccount, NSString * errorString);

@implementation RXUMSDK{
    
    id            _Controller;
    
    ShareType     _shareType;
    NSString    * _title;
    NSString    * _content;
    NSString    * _resourceId;
    NSData      * _imageData;
    UIControl   * _control;
    
    NSString    * _serverUrl;
    SHARECompletion _shareCompletion;
    
    long long     _userID;
    
    BOOL         _backApp;
    BackAppBlock _backAppBlock;
    
    BOOL         _isShare; //分享 操作
    BOOL         _isLogin; //登录 操作
    
}
- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, SHARE_VIEW_height)];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.alpha = 1.0;
        [self addSubview:toolbar];
        
        UILabel *titleLabel = [UILabel foundLabelWithFrame:CGRectMake(0, 0, ScreenWidth, 50) font:18.f textColor:GHS_666_COLOR textAlignment:NSTextAlignmentCenter];
        titleLabel.text = @"分享";
        [self addSubview:titleLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 49.5, ScreenWidth-40, 0.5)];
        line.backgroundColor = [UIColor redColor];
        [self addSubview:line];
        
        //微信好友
        UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
        button0.frame = CGRectMake((ScreenWidth-60*3)/4, CGRectGetMaxY(titleLabel.frame)+30, 60, 60);
        [button0 setBackgroundImage:GHSImageNamed(@"share_wechat") forState:UIControlStateNormal];
        button0.tag = 3000;
        [button0 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button0];
        
        UILabel *label0 = [UILabel foundLabelWithFrame:CGRectMake(0, CGRectGetMaxY(button0.frame)+10, 80, 15) font:12.f textColor:GHS_666_COLOR textAlignment:NSTextAlignmentCenter];
        label0.text = @"微信好友";
        label0.center = CGPointMake(button0.center.x, label0.center.y);
        [self addSubview:label0];
        
        //微信朋友圈
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake((ScreenWidth-60*3)/4*2+60, CGRectGetMaxY(titleLabel.frame)+30, 60, 60);
        [button1 setBackgroundImage:GHSImageNamed(@"share_wechat_friends") forState:UIControlStateNormal];
        button1.tag = 3001;
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        UILabel *label1 = [UILabel foundLabelWithFrame:CGRectMake(0, CGRectGetMaxY(button1.frame)+10, 80, 15) font:12.f textColor:GHS_666_COLOR textAlignment:NSTextAlignmentCenter];
        label1.text = @"朋友圈";
        label1.center = CGPointMake(button1.center.x, label1.center.y);
        [self addSubview:label1];
        
        //新浪微博
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake((ScreenWidth-60*3)/4*3+60*2, CGRectGetMaxY(titleLabel.frame)+30, 60, 60);
        [button2 setBackgroundImage:GHSImageNamed(@"share_sina") forState:UIControlStateNormal];
        button2.tag = 3002;
        [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        UILabel *label2 = [UILabel foundLabelWithFrame:CGRectMake(0, CGRectGetMaxY(button2.frame)+10, 80, 15) font:12.f textColor:GHS_666_COLOR textAlignment:NSTextAlignmentCenter];
        label2.text = @"新浪微博";
        label2.center = CGPointMake(button2.center.x, label2.center.y);
        [self addSubview:label2];
        
        //取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(0, 242-50, ScreenWidth, 50);
        [cancelButton setTitleColor:GHS_333_COLOR forState:UIControlStateNormal];
        //cancelButton.layer.borderColor = UIColorRGB(102, 102, 102).CGColor;
        //cancelButton.layer.borderWidth = 0.5;
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        _backApp = NO;
        _isShare = NO;
        _isLogin = NO;
        
        NSNotificationCenter * notifi = [NSNotificationCenter defaultCenter];
        [notifi addObserver:self selector:@selector(changeInAppStatue) name:OpenUrl_notifaction object:nil];
        [notifi addObserver:self selector:@selector(loginFailPostNotifacion) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}


- (void)buttonAction:(UIButton *)sender {
    
    
    
    NSInteger index = sender.tag-3000;
    
    if (![WXApi isWXAppInstalled] && index!=2)
    {
        [self hide];
        [self.superview makeToast:@"您未安装微信" duration:2  position:@"CSToastPositionCenter"];
        return;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMSocialPlatformType platformType = -1;
    
    NSString * content = GHSIsStringWithAnyText(_content) ? _content : _title;
    NSString * target = nil;
    if (index == 0) {
        //好友
        platformType = UMSocialPlatformType_WechatSession;
        target = @"微信";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:content thumImage:_imageData];
        [shareObject setWebpageUrl:_serverUrl];
        messageObject.shareObject = shareObject;
    }else if (index == 1) {
        platformType = UMSocialPlatformType_WechatTimeLine;
        //微信 朋友圈
        target = @"朋友圈";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:content thumImage:_imageData];
        [shareObject setWebpageUrl:_serverUrl];
        messageObject.shareObject = shareObject;
    }else if (index == 2) {
        platformType = UMSocialPlatformType_Sina;
        //新浪 分享内容多个链接
        content = [content stringByAppendingString:@" "];
        content = [content stringByAppendingString:_serverUrl];
        content = [content stringByAppendingString:@" "];
        target = @"微博";
        
        
        UMShareImageObject * shareObject = [UMShareImageObject shareObjectWithTitle:_title descr:content thumImage:_imageData];
        [shareObject setShareImage:_imageData];
        messageObject.shareObject = shareObject;
        messageObject.text = content;
    }
    
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_Controller completion:^(id result, NSError *error) {
        
        //        NSLog(@"分享结果=%@", result);
        if(error) {
            NSInteger errorCode = error.code;
            NSString * errorString = nil;
            if(errorCode == UMSocialPlatformErrorType_Cancel) {
                errorString = @"分享已取消";
            }else if(errorCode == UMSocialPlatformErrorType_ShareFailed) {
                errorString = @"分享失败";
            }
            else if(errorCode == UMSocialPlatformErrorType_AuthorizeFailed) {
                errorString = @"授权失败";
            }else if(errorCode == UMSocialPlatformErrorType_ShareDataNil) {
                errorString = @"分享内容为空";
            }else if(errorCode == UMSocialPlatformErrorType_NotNetWork) {
                errorString = @"没有网络";
            }else {
                errorString = @"未知错误";
            }
            _shareCompletion(errorString);
            
        }
        else {
            _shareCompletion(@"分享成功");
        }
    }];
    
    [self hide];
}
- (void)showShareWithViewController:(id)object  type:(ShareType)type title:(NSString *)title resourceId:(NSString *)resourceId image:(NSString *)image completion:(void (^)(NSString * result) )commpletion {
    [self showShareWithViewController:object type:type title:title content:nil resourceId:resourceId image:image completion:commpletion];
}


- (void)showShareWithViewController:(id)object  type:(ShareType)type title:(NSString *)title content:(NSString *)content resourceId:(NSString *)resourceId image:(NSString *)image completion:(void (^)(NSString *))commpletion {
    
    __weak typeof(object)weakObject = object;
    _Controller = weakObject;
    _shareType = type;
    _title = title;
    _resourceId = resourceId;
    _content = content;
    _imageData = [self dateContent:image];
    
    _backApp = YES;
    _isShare = YES;
    
    [self.superview bringSubviewToFront:self];
    
    _control = [[UIControl alloc]initWithFrame:self.superview.bounds];
    _control.backgroundColor = [UIColor blackColor];
    _control.alpha = 0.4;
    [_control addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.superview insertSubview:_control belowSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight - SHARE_VIEW_height, ScreenWidth, SHARE_VIEW_height);
    } completion:^(BOOL finished) {
        
        NSString * shareSeverUrl = [SERVER_URL stringByReplacingOccurrencesOfString:@"api" withString:@""];
        
        if (type == ShareTypeSku) {
            _serverUrl= [NSString stringWithFormat:@"%@/wap/productshare.html?sku=", shareSeverUrl];
            
            _serverUrl = [NSString stringWithFormat:@"%@%@",_serverUrl,GHSNonEmptyString(_resourceId)];
        }
        else if(type == ShareTypePlayer) {
            _serverUrl= [NSString stringWithFormat:@"%@/wap/wellgoodsshare.html?coupId=", shareSeverUrl];
            
            _serverUrl = [NSString stringWithFormat:@"%@%@",_serverUrl,GHSNonEmptyString(_resourceId)];
        }
        else if(type == ShareTypeWeb) {
            _serverUrl = shareSeverUrl;
        }
        
    }];
    
    _shareCompletion = commpletion;
}

- (void)showShareWithViewController:(id)object userID:(long long)userID URL:(NSString *)urlString title:(NSString *)title content:(NSString *)content  image:(id)image completion:(void (^)(NSString *))commpletion {
    _serverUrl = urlString;
    _content = content;
    _userID = userID;
    [self showShareWithViewController:object type:ShareTypeOther title:title content:content resourceId:nil image:image completion:commpletion];
}

- (void)cancelButtonAction {
    [self hide];
}

- (void)hide {
    
    [_control removeFromSuperview];
    _control = nil;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, SHARE_VIEW_height);
    } completion:^(BOOL finished) {
        
    }];
}



+ (NSString *)resourceId:(NSInteger)resourceId {
    return [NSString stringWithFormat:@"%zd", resourceId];
}

- (NSData *)dateContent:(NSString *)string {
    if(!GHSIsStringWithAnyText(string)) {
        return nil;
    }
    if([string urlBOOL]) {
        return UIImageJPEGRepresentation([UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:string]]], 0.1);
    }
    else {
        NSData * data =  UIImagePNGRepresentation([UIImage imageNamed:string]);
        if(data.length > 0) {
            return [NSData data];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:string])
        {
            return  UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfFile:string]], 0.1);
        }
        else {
            NSLog(@"分享的图片地址 不存在");
        }
        
        return nil;
    }
}



#pragma mark - ~~~~~~~~~~~ 第三方登录 ~~~~~~~~~~~~~~~
- (void)showLoginWithViewController:(id)object loginType:(LoginType)loginType completion:(void (^)(UMSocialUserInfoResponse *, NSString * errorString))completion {
    
    __weak typeof(object)weakObject = object;
    _Controller = weakObject;
    
    _backApp = YES;
    _isLogin = YES;
    
    
    UMSocialPlatformType shareType = -1;
    
    if(loginType == LoginTypeWX) {
        
        if(![WXApi isWXAppInstalled]) {
            completion(nil, @"请先安装微信");
            return;
        }
        
        //        //微信
        shareType = UMSocialPlatformType_WechatSession;
        
    }
    else if(loginType == LoginTypeSina) {
        //        //新浪微博
        shareType = UMSocialPlatformType_Sina;
    }
    
    
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:shareType completion:^(id result, NSError *error) {
        
        [[UMSocialManager defaultManager]  authWithPlatform:shareType currentViewController:_Controller completion:^(id result, NSError *error) {
            UMSocialAuthResponse *authresponse = result;
            NSString *message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,authresponse.uid,authresponse.accessToken];
            
            NSLog(@"授权结果：%@", message);
            
            if(!error) {
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:shareType currentViewController:_Controller completion:^(id result, NSError *error) {
                    UMSocialUserInfoResponse * response = result;
                    NSString *message = [NSString stringWithFormat:@"result: %d\n uid: %@\n name: %@\n  image=%@",(int)error.code,response.uid,response.name, response.iconurl];
                    NSLog(@"获取用户信息结果：%@", message);
                    completion(response, nil);
                    
                }];
            }
            else {
                NSString * errorString = nil;
                NSInteger errorCode = error.code;
                if(errorCode == UMSocialPlatformErrorType_Cancel) {
                    errorString = @"取消授权";
                }else if(errorCode == UMSocialPlatformErrorType_AuthorizeFailed) {
                    errorString = @"授权失败";
                }else if(errorCode == UMSocialPlatformErrorType_RequestForUserProfileFailed) {
                    errorString = @"请求用户信息失败";
                }else if(errorCode == UMSocialPlatformErrorType_ShareDataNil) {
                    errorString = @"分享内容为空";
                }else if(errorCode == UMSocialPlatformErrorType_NotNetWork) {
                    errorString = @"没有网络";
                }else {
                    errorString = @"未知错误";
                }
                
                completion(nil, errorString);
                
            }
        }];
    }];
    
    _backAppBlock = completion;
}

- (void)changeInAppStatue {
    _backApp = NO;
}

- (void)loginFailPostNotifacion {
    if(_backApp) {
        [self userCancelUM];
    }
}


- (void)userCancelUM {
//    if(_isShare) {
//        _shareCompletion(@"分享失败");
//    }
    
    if(_isLogin) {
        _backAppBlock(nil,@"授权失败");
    }
    
    _backApp = NO;
    _isShare = NO;
    _isLogin = NO;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
