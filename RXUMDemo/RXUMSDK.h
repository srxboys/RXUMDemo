//
//  RXUMSDK.h
//  RXUMDemo
//
//  Created by srx on 16/10/10.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeSku, //商品详情分享
    ShareTypePlayer, //鲨鱼玩家视频详情分享
    ShareTypeWeb,
    ShareTypeOther
};


typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeWX,
    LoginTypeSina
};


@interface RXUMSDK : UIView
/**
 *  分享 (商品详情页、玩家视频详情页)方便设置参数
 *
 *  这里的Url 是固定拼接的  注意。
 *
 *  @param object      UIViewControll
 *  @param type        分享界面的类型 (允许 sku/player/web  不允许【我的界面】)
 *  @param title       标题
 *  @param content      +  分享内容（如果为Nil就和title一样）
 *  @param resourceId  resourceId = sku/玩家id/
 *  @param image       图片 本地地址、url字符串
 *  @param commpletion 分享结束回调
 */
- (void)showShareWithViewController:(id)object  type:(ShareType)type title:(NSString *)title content:(NSString *)content resourceId:(NSString *)resourceId image:(NSString *)image completion:(void (^)(NSString *))commpletion ;


/**
 *  分享自定义
 *
 *  @param object      UIViewControll
 *  @param urlString   自定义分享地址
 *  @param title       标题
 *  @param content     内容说明（如果为Nil就和title一样
 *  @param image       图片 本地地址、url字符串
 *  @param commpletion 分享结束回调
 */
- (void)showShareWithViewController:(id)object userID:(long long)userID URL:(NSString *)urlString title:(NSString *)title content:(NSString *)content image:(NSString *)image completion:(void (^)(NSString * result) )commpletion;


/// 把【数值类型】取整转【字符串】
+ (NSString *)resourceId:(NSInteger)resourceId;


/**
 *  第三方登录 <微信、微博>
 *
 *  @param object     UIViewControll
 *  @param loginType  登录方式(微信、微博)
 *  @param completion 登录结束回调
 *
 * 如果 snsAccount != nil  && errorString = nil ,说明认证成功
 * 如果 snsAccount == nil  ,说明认证失败，失败信息为 errorString
 */
- (void)showLoginWithViewController:(id)object loginType:(LoginType)loginType completion:(void (^)(UMSocialUserInfoResponse * snsAccount, NSString * errorString))completion;

@end
