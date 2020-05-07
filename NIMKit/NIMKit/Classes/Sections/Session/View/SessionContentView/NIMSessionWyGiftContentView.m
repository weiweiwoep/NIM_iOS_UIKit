//
//  NIMSessionImageContentView.m
//  NIMKit
//
//  Created by chris on 15/1/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionWyGiftContentView.h"
#import "NIMMessageModel.h"
#import "UIView+NIM.h"
#import "NIMLoadProgressView.h"
#import "NIMKitDependency.h"
#import <YYImage/YYImage.h>
#import "NIMWyGiftAttachment.h"
#import "WyGiftModel.h"
#import <SVGAPlayer/SVGA.h>
#import "NIMGlobalMacro.h"
#import "UIImage+NIMKit.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface NIMSessionWyGiftContentView()<SVGAPlayerDelegate>

@property (nonatomic,strong,readwrite) YYAnimatedImageView * imageView;

@property (nonatomic,strong) NIMLoadProgressView * progressView;

@property (nonatomic, strong) SVGAPlayer *aPlayer;

@property (nonatomic, strong) YYAnimatedImageView *gifPlayer;

@end

static SVGAParser *parser;

@implementation NIMSessionWyGiftContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        _progressView = [[NIMLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0f;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    _imageView.image = nil;
    
    if (![self.model.message.messageObject isKindOfClass:NIMCustomObject.class]) return;
    NIMCustomObject *customObj = (NIMCustomObject *)self.model.message.messageObject;
    
    if (![customObj.attachment isKindOfClass:NIMWyGiftAttachment.class]) return;
    NIMWyGiftAttachment *wyGiftAttachment = (NIMWyGiftAttachment *)customObj.attachment;
    WyGiftModel *wyGift = wyGiftAttachment.wyGift;
    
    YYImage *image = [YYImage imageWithData:wyGift.img_data scale:[UIScreen mainScreen].scale];
    _imageView.image = image;
    
    self.progressView.hidden     = self.model.message.isOutgoingMsg ? (self.model.message.deliveryState != NIMMessageDeliveryStateDelivering) : (self.model.message.attachmentDownloadState != NIMMessageAttachmentDownloadStateDownloading);
    if (!self.progressView.hidden) {
        [self.progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.model.message]];
    }
    
    //播放礼物
    long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    if (customObj.message.isReceivedMsg && wyGift.gif_url != nil && wyGift.gif_url.length > 0 && (currentTimeStamp-customObj.message.timestamp)<60*1) {
        
        NSString *pathExtension = [wyGift.gif_url pathExtension];
        if ([pathExtension isEqualToString:@"gif"]) {
            [self playGifWithGift:wyGift];
        }else{
            [self playSvgaWyGift:wyGift];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.nim_width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.imageView.frame  = imageViewFrame;
    _progressView.frame   = self.bounds;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
}


- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapContent;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

- (void)updateProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.progressView.progress = progress;
}

- (void)playGifWithGift:(WyGiftModel *)wyGift{
    NIMKit_Dispatch_Async_Main(^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self.gifPlayer];
        self.gifPlayer.contentMode = UIViewContentModeCenter;
        self.gifPlayer.frame = CGRectMake(0, 0, NIMKit_UIScreenWidth, NIMKit_UIScreenHeight);
        
        UIImage *image = [YYImage imageWithData:wyGift.gif_data];
        [self.gifPlayer setImage:image];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [RACObserve(self.gifPlayer, currentAnimatedImageIndex) subscribeNext:^(id _Nullable index) {
                if ([index integerValue] == self.gifPlayer.animationImages.count) {
                    [self.gifPlayer stopAnimating];
                    [self.gifPlayer removeFromSuperview];
                }
            }];
        });
    });
}

- (void)playSvgaWyGift:(WyGiftModel *)wyGift{
    NIMKit_Dispatch_Async_Main(^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self.aPlayer];
        self.aPlayer.delegate = self;
        self.aPlayer.frame = CGRectMake(0, 0, NIMKit_UIScreenWidth, NIMKit_UIScreenHeight);
        self.aPlayer.loops = 1;
        self.aPlayer.clearsAfterStop = YES;
        
        parser = [[SVGAParser alloc] init];
        
        [parser parseWithData:wyGift.gif_data cacheKey:wyGift.gif_url completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (videoItem != nil) {
                self.aPlayer.videoItem = videoItem;
                [self.aPlayer startAnimation];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            [self.aPlayer removeFromSuperview];
        }];
        
//        [parser parseWithURL:[NSURL URLWithString:wyGift.gif_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            if (videoItem != nil) {
//                self.aPlayer.videoItem = videoItem;
//                [self.aPlayer startAnimation];
//            }
//        } failureBlock:^(NSError * _Nullable error) {
//            [self.aPlayer removeFromSuperview];
//        }];
    });
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    [self.aPlayer removeFromSuperview];
}

#pragma mark - getter

- (YYAnimatedImageView *)gifPlayer{
    if (_gifPlayer == nil) {
        _gifPlayer = [[YYAnimatedImageView alloc] init];
    }
    return _gifPlayer;
}

- (SVGAPlayer *)aPlayer {
    if (_aPlayer == nil) {
        _aPlayer = [[SVGAPlayer alloc] init];
    }
    return _aPlayer;
}

@end
