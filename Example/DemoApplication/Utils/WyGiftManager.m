//
//  WyGiftManager.m
//  DemoApplication
//
//  Created by carlw on 2020/4/24.
//  Copyright © 2020 chrisRay. All rights reserved.
//

#import "WyGiftManager.h"
#import <NIMKit/NIMKit.h>
#import "NTESCellLayoutConfig.h"
#import "HttpManager.h"
#import <TMCache/TMCache.h>
#import <NIMKit/NIMInputWyGiftDefine.h>
#import "WyGiftModel.h"

//#import <NIMKit/Wy>

@implementation WyGiftManager

+ (void) giftList {
    [HttpManager requestPostWithUrl:@"mobile/gift/index" stringCallBack:^(NSString * _Nonnull content) {
    } callBack:^(WyResponse * _Nonnull response) {
        JSONModelError *error = nil;
        if (!error && response.data) {
            NSArray *list = [WyGiftModel arrayOfModelsFromDictionaries:response.data error:&error];
            if (error || list == nil || list.count < 1) {
                return;
            }
            //下载图片资源
            for (WyGiftModel *gift in list) {
                gift.img_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:gift.img_url]];
                gift.gif_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:gift.gif_url]];
            }
            //更新缓存
            [TMCache.sharedCache removeObjectForKey:Key_WyNim_InputGiftData];
            [TMCache.sharedCache setObject:list forKey:Key_WyNim_InputGiftData];
            
            [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
        }
    }error:^(NSException * _Nonnull error) {
        NSLog(@"'聊天礼物菜单元素获取失败:'%@",error.description);
    }];
}
@end
