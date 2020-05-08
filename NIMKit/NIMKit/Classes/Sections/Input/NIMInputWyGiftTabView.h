//
//  NIMInputEmoticonTabView.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NIMInputWyGiftTabView;

@protocol NIMInputWyGiftTabDelegate <NSObject>

- (void)tabView:(NIMInputWyGiftTabView *)tabView didSelectTabIndex:(NSInteger) index;

- (void)onTouchRecharge;        //充值

- (NSString *)getGoldCoin;      //金币余额

@end

@interface NIMInputWyGiftTabView : UIControl

@property (nonatomic,strong) UIButton * sendButton;

@property (nonatomic,weak)   id<NIMInputWyGiftTabDelegate>  delegate;

- (void)selectTabIndex:(NSInteger)index;

- (void)loadCatalogs:(NSArray*)emoticonCatalogs;

@end






