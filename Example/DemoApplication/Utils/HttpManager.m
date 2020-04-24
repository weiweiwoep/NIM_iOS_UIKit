//
//  HttpManager.m
//  wnl3
//
//  Created by 魏伟 on 2020/2/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "HttpManager.h"
#import "WyConsts.h"

@implementation HttpManager

+ (void)requestGetWithUrl:(NSString *)urlString stringCallBack:(CallBackStringBlock)stringCallBack callBack:(CallBackBlock) callBack error:(ErrorBackBlock)error {
    @try {
        
        NSString *hostUrlString = [NSString stringWithFormat:@"%@%@",WY_APP_HOST,urlString];
        NSURL *url = [NSURL URLWithString:hostUrlString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *session=[NSURLSession sharedSession];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"网络响应：response：%@",response);
            NSString *content = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"请求结果：content：%@",content);
            
            JSONModelError *jsonError = nil;
            WyResponse *wyResponse = [WyResponse.alloc initWithString:content error:&jsonError];
            if (jsonError || !wyResponse) {
                stringCallBack(content);
            }else{
                callBack(wyResponse);
            }
        }] resume];
    } @catch (NSException *exception) {
        error(exception);
    }
}

+ (void)requestPostWithUrl:(NSString *)urlString stringCallBack:(CallBackStringBlock)stringCallBack callBack:(CallBackBlock) callBack error:(ErrorBackBlock)error{
    @try {
        NSString *hostUrlString = [NSString stringWithFormat:@"%@%@",WY_APP_HOST,urlString];
        NSURL *url = [NSURL URLWithString:hostUrlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        NSURLSession *session=[NSURLSession sharedSession];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"网络响应：response：%@",response);
            NSString *content = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"请求结果：content：%@",content);
            JSONModelError *jsonError = nil;
            WyResponse *wyResponse = [WyResponse.alloc initWithString:content error:&jsonError];
            if (jsonError || !wyResponse) {
                stringCallBack(content);
            }else{
                callBack(wyResponse);
            }
        }] resume];
    } @catch (NSException *exception) {
        error(exception);
    }
}

@end
