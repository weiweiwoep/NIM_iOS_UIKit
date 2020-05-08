//
//  NTESSessionViewController.m
//  DemoApplication
//
//  Created by chris on 15/10/7.
//  Copyright © 2015年 chris. All rights reserved.
//

#import "NTESSessionViewController.h"
#import "NTESSessionConfig.h"
#import "NTESAttachment.h"

@interface NTESSessionViewController ()

@property (nonatomic,strong) NTESSessionConfig *config;

@end

@implementation NTESSessionViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithSession:session];
    if (self) {
        _config = [[NTESSessionConfig alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)sessionTitle{
    return @"聊天";
}

- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}


#pragma mark - Private
- (void)sendCustomMessage{
    //构造自定义内容
    NTESAttachment *attachment = [[NTESAttachment alloc] init];
    attachment.title = @"这是一条自定义消息";
    attachment.subTitle = @"这是自定义消息的副标题";
    
    //构造自定义MessageObject
    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    object.attachment = attachment;
    
    //构造自定义消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:self.session error:nil];
}

- (void)onTapMediaItemVideoChat{
    //语音通话
    NSLog(@"唤起语音通话!");
}

//获取用户余额,需二次业务开发
- (NSString *)getGoldCoin{
    return @"8888";
}

//充值,需二次业务开发
-(void)onTouchRecharge{
    NSLog(@"充值,需二次业务开发:%s",__func__);
}

//是否允许发送消息
- (BOOL)allowSendMessage{
    return YES;
}

@end
