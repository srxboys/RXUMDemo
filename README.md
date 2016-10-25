# RXUMDemo
###iOS object-C 社会化组件SDK v6.0.0（2016-9-23）
###             分享、第三方平台授权 自封装
-

```objc
    // 分享
    [_shareView showShareWithViewController:self type:ShareTypeSku 
    title:@"欧哥斯家用制氧机" content:@"好消息" resourceId:@"9113767" 
    image:imageURL completion:^(NSString *result) {
        // code
    }
    
     // 授权登录 `LoginType`=(LoginTypeWX, LoginTypeSina)
     [_shareView showLoginWithViewController:self  loginType:`LoginType` 
    completion:^(UMSocialUserInfoResponse *snsAccount, NSString *errorString) {
        // code
    }
```
![srxboys](https://github.com/srxboys/RXUMDemo/blob/master/RXUMDemo1/srxboys_UMShare.gif)

-
-
-

###第二版 完全自定义分享到哪些平台
#### 我只写了一部分，友盟有多少，就可以写多少
```objc

    #import "RXUMShare.h"
    //viewDidLoad里
    _share = [[RXUMShare alloc] init];
    [self.view addSubview:_share];


    //分享按钮点击 操作
    //platforms:@[这里可以根据每个页面需求，你想要分享的多个平台]
    [_share shareInController:self platforms:@[UMSPlatformNameQQ, UMSPlatformNameQzone, UMSPlatformNameWechatSession, UMSPlatformNameTencentWb , UMSPlatformNameSina] title:@"标题" contents:@"分享内容" imageURLString:@"图片url" completion:^(NSString *result) {
    //result=分享成功、失败等等信息
}];
````
![srxboys](https://github.com/srxboys/RXUMDemo/blob/master/RXUMDemo2/srxboys_UMDemo2.gif)

-

如果你有想说的可以 [issues I](https://github.com/srxboys/RXUMDemo/issues/new) 。
:sweat_smile::sweat_smile::sweat_smile::sweat_smile::sweat_smile:
