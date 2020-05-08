//
//  NIMInputWyGiftContainerView.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMPageView.h"
#import "NIMSessionConfig.h"

@class NIMInputWyGiftCatalog;
@class NIMInputWyGiftTabView;

@protocol NIMInputWyGiftProtocol <NSObject>

- (void)didPressSend:(id)sender;

-(void)onTapRecharge;       //充值

- (NSString *)getGoldCoin;      //金币余额

- (void)selectedWyGift:(NSString*)wyGiftID catalog:(NSString*)wyGiftCatalogID description:(NSString *)description;

@end


@interface NIMInputWyGiftContainerView : UIView<NIMPageViewDataSource,NIMPageViewDelegate>

@property (nonatomic, strong)  NIMPageView *wyGiftPageView;
@property (nonatomic, strong)  UIPageControl  *wyGiftPageController;
@property (nonatomic, strong)  NSArray                    *totalCatalogData;
@property (nonatomic, strong)  NIMInputWyGiftCatalog    *currentCatalogData;
@property (nonatomic, readonly)NSArray            *allWyGifts;
@property (nonatomic, strong)  NIMInputWyGiftTabView   *tabView;
@property (nonatomic, weak)    id<NIMInputWyGiftProtocol>  delegate;
@property (nonatomic, weak)    id<NIMSessionConfig> config;

@end

