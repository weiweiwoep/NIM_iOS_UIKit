//
//  NTESAppDelegate.m
//  DemoApplication
//
//  Created by chris on 15/10/7.
//  Copyright © 2015年 chris. All rights reserved.
//

#import "NTESAppDelegate.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESCellLayoutConfig.h"
#import "NTESAttachmentDecoder.h"
#import <NIMKit/NIMKit.h>
//#import "NIMWyGiftAttachmentDecoder.h"
#import "WyGiftManager.h"
#define NIMSDKAppKey @"8fc95f505b6cbaedf613677c8e08fc0b"

@interface NTESAppDelegate ()

@end

@implementation NTESAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册APP，请将 NIMSDKAppKey 换成您自己申请的App Key
    [[NIMSDK sharedSDK] registerWithAppID:NIMSDKAppKey cerName:nil];
    
    //需要自定义消息时使用
//    [NIMCustomObject registerCustomDecoder:[[NTESAttachmentDecoder alloc]init]];
    
    //开启控制台调试
    [[NIMSDK sharedSDK] enableConsoleLog];
    
    //注入 NIMKit 布局管理器
//    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
    
    //加载礼物
    [WyGiftManager giftList];
    
    return YES;
}


@end
