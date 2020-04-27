//
//  WyGiftManager.m
//  DemoApplication
//
//  Created by carlw on 2020/4/24.
//  Copyright © 2020 chrisRay. All rights reserved.
//

#import "WyGiftManager.h"
#import "HttpManager.h"
#import <TMCache/TMCache.h>
#import <NIMKit/NIMInputWyGiftDefine.h>

//#import <NIMKit/Wy>

@implementation WyGiftManager

+ (void) giftList {
    [HttpManager requestPostWithUrl:@"mobile/gift/index" stringCallBack:^(NSString * _Nonnull content) {
    } callBack:^(WyResponse * _Nonnull response) {
        JSONModelError *error = nil;
        if (!error && response.data) {
            //更新缓存
            [TMCache.sharedCache removeObjectForKey:Key_WyNim_InputGiftData];
            [TMCache.sharedCache setObject:response.data forKey:Key_WyNim_InputGiftData];
        }
    }error:^(NSException * _Nonnull error) {
        NSLog(@"'聊天礼物菜单元素获取失败:'%@",error.description);
    }];
}
@end
