//
//  HttpManager.h
//  wnl3
//
//  Created by 魏伟 on 2020/2/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WyResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBackStringBlock)(NSString *content);  // 定义带有参数text的block

typedef void(^CallBackBlock)(WyResponse *response);    // 定义带有参数对象的block

typedef void(^ErrorBackBlock)(NSException *error);

@interface HttpManager<T: JSONModel *> : NSObject

+ (void)requestGetWithUrl:(NSString *)urlString stringCallBack:(CallBackStringBlock)stringCallBack callBack:(CallBackBlock) callBack error:(ErrorBackBlock)error;

+ (void)requestPostWithUrl:(NSString *)urlString stringCallBack:(CallBackStringBlock)stringCallBack callBack:(CallBackBlock) callBack error:(ErrorBackBlock)error;

@end

NS_ASSUME_NONNULL_END
