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
![srxboys](https://github.com/srxboys/RXUMDemo/blob/master/srxboys_UMShare.gif)

-

如果你有想说的可以 [issues I](https://github.com/srxboys/RXUMDemo/issues/new) 。
:sweat_smile::sweat_smile::sweat_smile::sweat_smile::sweat_smile:
