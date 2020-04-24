//
//  WyGiftManager.m
//  DemoApplication
//
//  Created by carlw on 2020/4/24.
//  Copyright © 2020 chrisRay. All rights reserved.
//

#import "WyGiftManager.h"

#import "WyResponse.h"

#import "WyGiftModel.h"

#import "HttpManager.h"

@implementation WyGiftManager

+ (void) giftList {
    [HttpManager requestPostWithUrl:@"mobile/gift/index" stringCallBack:^(NSString * _Nonnull content) {
        } callBack:^(WyResponse * _Nonnull response) {
        JSONModelError *error = nil;
        NSArray *list = [WyGiftModel arrayOfModelsFromDictionaries:response.data error:&error];
        if (!error && list) {
            
        }
    }error:^(NSException * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}
@end
