//
//  RXCharacter.h
//  RXUMDemo2
//
//  Created by srx on 2016/10/25.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///对请求参数做处理
@interface NSObject (strNotEmptyValue)
- (NSString *)strNotEmptyValue;
@end

///判断字符串是否为空
@interface NSObject (strBOOL)
- (BOOL)strBOOL;
@end

///是否是数组
@interface NSObject (arrBOOL)
- (BOOL)arrBOOL;
@end


///返回【判断后的数组】-- 如果是字典以数组形式返回
@interface NSObject (arrValue)
- (NSArray *)arrValue;
@end

///判断字符串是否 为 Url
@interface NSObject (urlBOOL)
- (BOOL)urlBOOL;
@end

@interface NSObject (fromatValue)
- (NSString *)formatMonery;
@end
